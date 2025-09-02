import { clx, Text } from "@medusajs/ui"
import { getProductPrice } from "@/lib/util/get-product-price"
import { HttpTypes } from "@medusajs/types"

export default function ProductPrice({
  product,
}: {
  product: HttpTypes.StoreProduct
}) {
  const { cheapestPrice } = getProductPrice({
    product,
  })

  if (!cheapestPrice) {
    return <div className="block w-32 h-9 bg-background-secondary animate-pulse" />
  }

  return (
    <div className="flex flex-col text-white">
      <span
        className={clx({
          "text-accent": cheapestPrice.price_type === "sale",
        })}
      >
        <Text
          className="font-medium text-xl"
          data-testid="product-price"
          data-value={cheapestPrice.calculated_price_number}
        >
          From {cheapestPrice.calculated_price}
        </Text>
        <Text className="text-pharmint-muted text-[0.6rem]">Excl. VAT</Text>
      </span>
      {cheapestPrice.price_type === "sale" && (
        <p
          className="line-through text-pharmint-muted"
          data-testid="original-product-price"
          data-value={cheapestPrice.original_price_number}
        >
          {cheapestPrice.original_price}
        </p>
      )}
    </div>
  )
}
