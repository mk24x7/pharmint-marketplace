import type { MedusaRequest, MedusaResponse } from "@medusajs/framework";
import { updateLineItemInCartWorkflow, deleteLineItemsWorkflow } from "@medusajs/medusa/core-flows";
import { MedusaError } from "@medusajs/utils";
import { StoreUpdateCartLineItemType } from "@medusajs/medusa/api/store/carts/validators";
import { refetchCartWithRetry, debugCartQuery } from "../../../helpers";

/**
 * Custom line item update route that addresses the "Line item not found" issue
 * This route includes proper error handling and persistence verification
 */
export async function POST(
  req: MedusaRequest<StoreUpdateCartLineItemType>,
  res: MedusaResponse
) {
  const { id: cartId, line_id } = req.params;
  
  console.log(`🔧 Updating line item ${line_id} in cart ${cartId}`);

  try {
    // First, fetch the cart with retries to handle timing issues
    const cart = await refetchCartWithRetry(
      cartId, 
      req.scope, 
      ["id", "region_id", "customer_id", "sales_channel_id", "currency_code", "*items"],
      3,
      100
    );

    console.log(`📋 Cart ${cartId} has ${cart.items?.length || 0} items`);

    // Find the line item in the cart
    const item = cart.items?.find((i) => i.id === line_id);
    
    if (!item) {
      console.error(`❌ Line item ${line_id} not found in cart ${cartId}`);
      console.log(`Available line items:`, cart.items?.map(i => ({ id: i.id, variant_id: i.variant_id, quantity: i.quantity })));
      
      // Use debug cart query to understand what's happening
      await debugCartQuery(cartId, req.scope, ["id", "*items"]);
      
      throw new MedusaError(
        MedusaError.Types.NOT_FOUND, 
        `Line item with id: ${line_id} was not found in cart ${cartId}. Available items: ${cart.items?.map(i => i.id).join(', ') || 'none'}`
      );
    }

    console.log(`✅ Found line item ${line_id}, current quantity: ${item.quantity}`);

    // Run the update workflow
    await updateLineItemInCartWorkflow(req.scope).run({
      input: {
        cart_id: cartId,
        item_id: item.id,
        update: req.validatedBody,
      },
    });

    console.log(`🔄 Line item update workflow completed`);

    // Refetch the updated cart with retries
    const updatedCart = await refetchCartWithRetry(
      cartId, 
      req.scope, 
      req.queryConfig.fields,
      3,
      150
    );

    console.log(`🎉 Line item ${line_id} updated successfully in cart ${cartId}`);

    res.status(200).json({ cart: updatedCart });

  } catch (error) {
    console.error(`❌ Error updating line item ${line_id} in cart ${cartId}:`, error);

    // Try to provide detailed error information
    try {
      const debugCart = await debugCartQuery(cartId, req.scope, ["id", "*items"]);
      console.error(`Debug cart info:`, {
        cartExists: !!debugCart,
        itemCount: debugCart?.items?.length || 0,
        itemIds: debugCart?.items?.map(i => i.id) || []
      });
    } catch (debugError) {
      console.error(`Debug query also failed:`, debugError);
    }

    throw error;
  }
}

/**
 * Custom line item delete route with enhanced error handling
 */
export async function DELETE(
  req: MedusaRequest,
  res: MedusaResponse
) {
  const { id: cartId, line_id } = req.params;
  
  console.log(`🗑️  Deleting line item ${line_id} from cart ${cartId}`);

  try {
    // Verify the cart and line item exist before deletion
    const cart = await refetchCartWithRetry(
      cartId,
      req.scope,
      ["id", "*items"],
      3,
      100
    );

    const item = cart.items?.find((i) => i.id === line_id);
    
    if (!item) {
      console.error(`❌ Line item ${line_id} not found in cart ${cartId} for deletion`);
      
      throw new MedusaError(
        MedusaError.Types.NOT_FOUND,
        `Line item with id: ${line_id} was not found in cart ${cartId}`
      );
    }

    // Run the delete workflow
    await deleteLineItemsWorkflow(req.scope).run({
      input: { cart_id: cartId, ids: [line_id] },
    });

    // Refetch the updated cart
    const updatedCart = await refetchCartWithRetry(
      cartId,
      req.scope,
      req.queryConfig.fields,
      3,
      150
    );

    console.log(`🗑️✅ Line item ${line_id} deleted successfully from cart ${cartId}`);

    res.status(200).json({
      id: line_id,
      object: "line-item",
      deleted: true,
      parent: updatedCart,
    });

  } catch (error) {
    console.error(`❌ Error deleting line item ${line_id} from cart ${cartId}:`, error);
    throw error;
  }
}