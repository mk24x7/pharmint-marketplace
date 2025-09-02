import { VariantPrice } from "@/lib/util/get-product-price"
import { Text, clx } from "@medusajs/ui"

// TODO: Price needs to access price list type
export default async function PreviewPrice({ price }: { price: VariantPrice }) {
  if (!price) {
    return null
  }

  return (
    <div className="flex flex-col gap-0.5">
      {price.price_type === "sale" && (
        <Text
          className="line-through text-pharmint-muted text-sm"
          data-testid="original-price"
        >
          {price.original_price}
        </Text>
      )}

      <Text
        className={clx("font-semibold text-lg", {
          "text-accent": price.price_type === "sale",
          "text-white": price.price_type !== "sale",
        })}
        data-testid="price"
      >
        {price.calculated_price}
      </Text>
    </div>
  )
}
