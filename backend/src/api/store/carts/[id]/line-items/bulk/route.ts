import type { MedusaRequest, MedusaResponse } from "@medusajs/framework";
import { addToCartWorkflow } from "@medusajs/medusa/core-flows";
import { ContainerRegistrationKeys } from "@medusajs/utils";
import { StoreAddLineItemsBulkType } from "../../../validators";
import { refetchCartWithRetry, verifyLineItemsExist, debugCartQuery } from "../../../helpers";

export async function POST(
  req: MedusaRequest<StoreAddLineItemsBulkType>,
  res: MedusaResponse
) {
  const { id } = req.params;
  const { line_items } = req.validatedBody;
  const query = req.scope.resolve(ContainerRegistrationKeys.QUERY);

  // First verify the cart exists and get detailed cart info
  const {
    data: [cart],
  } = await query.graph(
    {
      entity: "cart",
      fields: req.queryConfig.fields,
      filters: { id },
    },
    { throwIfKeyNotFound: true }
  );

  if (!cart) {
    throw new Error(`Cart with id ${id} not found`);
  }

  // Ensure we're using cart_id for the workflow (per Medusa documentation)
  const workflowInput = {
    cart_id: cart.id, // Use cart.id explicitly, not passing full cart object
    items: line_items,
  };

  try {
    // Log cart state before workflow execution
    console.log(`🚀 Starting bulk add to cart for cart ${cart.id} with ${line_items.length} items`);
    
    // Run the workflow and wait for completion
    const workflowResult = await addToCartWorkflow(req.scope).run({
      input: workflowInput,
    });

    console.log(`✅ Workflow completed for cart ${cart.id}`);

    // Use the enhanced cart refetch with retry logic
    const updatedCart = await refetchCartWithRetry(
      cart.id, 
      req.scope, 
      req.queryConfig.fields,
      3, // max retries
      150 // delay between retries
    );

    // Verify that line items were actually created
    const expectedItemCount = line_items.length + (cart.items?.length || 0);
    await verifyLineItemsExist(cart.id, expectedItemCount, req.scope);

    console.log(`🎉 Successfully added ${line_items.length} items to cart ${cart.id}`);

    res.json({ cart: updatedCart });

  } catch (error) {
    console.error("Error in bulk add to cart:", error);
    
    // Try to return current cart state even if workflow failed
    try {
      const fallbackCart = await debugCartQuery(cart.id, req.scope, req.queryConfig.fields);
      
      if (fallbackCart) {
        res.status(500).json({
          message: "Failed to add items to cart",
          error: error.message,
          cart: fallbackCart
        });
        return;
      }
    } catch (fallbackError) {
      console.error("Fallback cart query failed:", fallbackError);
    }
    
    throw error;
  }
}
