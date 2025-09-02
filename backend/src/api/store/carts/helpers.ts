import { ContainerRegistrationKeys, MedusaError } from "@medusajs/utils";

/**
 * Custom cart refetch helper that addresses timing issues with line item persistence
 * This is a workaround for the Medusa 2.4 addToCartWorkflow timing bug
 */
export const refetchCartWithRetry = async (
  cartId: string, 
  scope: any, 
  fields: string[],
  maxRetries: number = 3,
  delay: number = 100
) => {
  const query = scope.resolve(ContainerRegistrationKeys.QUERY);
  
  let lastError: Error | null = null;
  
  for (let attempt = 0; attempt < maxRetries; attempt++) {
    try {
      const { data: [cart] } = await query.graph(
        {
          entity: "cart",
          fields,
          filters: { id: cartId },
        },
        { throwIfKeyNotFound: true }
      );
      
      if (cart) {
        return cart;
      }
    } catch (error) {
      lastError = error as Error;
      console.warn(`Cart refetch attempt ${attempt + 1} failed:`, error);
      
      // Add delay between retries to allow for database persistence
      if (attempt < maxRetries - 1) {
        await new Promise(resolve => setTimeout(resolve, delay * (attempt + 1)));
      }
    }
  }
  
  throw new MedusaError(
    MedusaError.Types.NOT_FOUND,
    `Cart with id: ${cartId} was not found after ${maxRetries} attempts. Last error: ${lastError?.message}`
  );
};

/**
 * Verify that line items exist in the cart after workflow execution
 * This helps identify the timing/persistence issue
 */
export const verifyLineItemsExist = async (
  cartId: string,
  expectedLineItemCount: number,
  scope: any,
  fields: string[] = ["id", "*items"]
) => {
  const cart = await refetchCartWithRetry(cartId, scope, fields);
  
  if (!cart.items || cart.items.length === 0) {
    throw new MedusaError(
      MedusaError.Types.NOT_FOUND,
      `No line items found in cart ${cartId}. Expected ${expectedLineItemCount} items.`
    );
  }
  
  console.log(`✓ Cart ${cartId} verification: Found ${cart.items.length} line items, expected ${expectedLineItemCount}`);
  
  return cart;
};

/**
 * Enhanced cart query that includes debugging information
 */
export const debugCartQuery = async (
  cartId: string,
  scope: any,
  fields: string[]
) => {
  const query = scope.resolve(ContainerRegistrationKeys.QUERY);
  
  try {
    // Query the specific cart
    const { data: carts } = await query.graph(
      {
        entity: "cart",
        fields: [...fields, "created_at", "updated_at"],
        filters: { id: cartId },
      }
    );
    
    console.log(`🔍 Cart query debug for ${cartId}:`, {
      found: carts.length,
      cartIds: carts.map(c => c.id),
      cartCreatedAts: carts.map(c => c.created_at),
    });
    
    if (carts.length === 0) {
      // Query all carts to see what's available (debugging)
      const { data: allCarts } = await query.graph(
        {
          entity: "cart",
          fields: ["id", "created_at"],
        }
      );
      
      console.log(`📊 Available carts in database:`, {
        total: allCarts.length,
        cartIds: allCarts.slice(0, 5).map(c => c.id), // Show first 5
      });
    }
    
    return carts[0] || null;
  } catch (error) {
    console.error(`❌ Cart query failed for ${cartId}:`, error);
    throw error;
  }
};