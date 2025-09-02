"use client"

import { addToCartEventBus } from "@/lib/data/cart-event-bus"
import { StoreProduct, StoreRegion } from "@medusajs/types"
import { Button } from "@medusajs/ui"
import ShoppingBag from "@/modules/common/icons/shopping-bag"
import { useState } from "react"

const PreviewAddToCart = ({
  product,
  region,
}: {
  product: StoreProduct
  region: StoreRegion
}) => {
  const [isAdding, setIsAdding] = useState(false)

  const handleAddToCart = async () => {
    if (!product?.variants?.[0]?.id) return null

    setIsAdding(true)

    addToCartEventBus.emitCartAdd({
      lineItems: [
        {
          productVariant: {
            ...product?.variants?.[0],
            product,
          },
          quantity: 1,
        },
      ],
      regionId: region.id,
    })

    setIsAdding(false)
  }
  return (
    <Button
      className="rounded-full p-2.5 bg-accent hover:bg-accent-hover border-none shadow-none min-w-[40px] min-h-[40px] transition-all duration-200"
      onClick={(e) => {
        e.preventDefault()
        handleAddToCart()
      }}
      isLoading={isAdding}
      disabled={!product?.variants?.[0]?.id || isAdding}
    >
      <ShoppingBag size={16} fill="currentColor" />
    </Button>
  )
}

export default PreviewAddToCart
