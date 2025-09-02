import { getProductPrice } from "@/lib/util/get-product-price"
import { HttpTypes } from "@medusajs/types"
import { Text, clx } from "@medusajs/ui"
import LocalizedClientLink from "@/modules/common/components/localized-client-link"
import Thumbnail from "../thumbnail"
import PreviewAddToCart from "./preview-add-to-cart"
import PreviewPrice from "./price"

export default async function ProductPreview({
  product,
  isFeatured,
  region,
}: {
  product: HttpTypes.StoreProduct
  isFeatured?: boolean
  region: HttpTypes.StoreRegion
}) {
  if (!product) {
    return null
  }

  const { cheapestPrice } = getProductPrice({
    product,
  })

  const inventoryQuantity = product.variants?.reduce((acc, variant) => {
    return acc + (variant?.inventory_quantity || 0)
  }, 0)

  return (
    <LocalizedClientLink href={`/products/${product.handle}`} className="group h-full">
      <div
        data-testid="product-wrapper"
        className="flex flex-col h-full w-full overflow-hidden p-6 bg-background-secondary border border-pharmint-border rounded-xl group-hover:border-accent group-hover:shadow-lg group-hover:shadow-accent/10 transition-all ease-in-out duration-200"
      >
        {/* Image Container - Fixed Height */}
        <div className="relative w-full h-48 mb-4 flex items-center justify-center bg-white/5 rounded-lg">
          <Thumbnail
            thumbnail={product.thumbnail}
            images={product.images}
            size="square"
            isFeatured={isFeatured}
            className="w-full h-full object-contain"
          />
        </div>
        
        {/* Content Container - Flexible Height with Consistent Spacing */}
        <div className="flex flex-col flex-1 gap-3">
          {/* Brand and Title - Fixed Height Container */}
          <div className="flex flex-col gap-1 min-h-[3.5rem]">
            <Text className="text-pharmint-muted text-xs font-medium tracking-wide uppercase">
              BRAND
            </Text>
            <Text 
              className="text-white font-medium leading-tight line-clamp-2" 
              data-testid="product-title"
              title={product.title}
            >
              {product.title}
            </Text>
          </div>
          
          {/* Price Section - Fixed Height */}
          <div className="flex flex-col gap-1 min-h-[2.5rem]">
            {cheapestPrice && <PreviewPrice price={cheapestPrice} />}
            <Text className="text-pharmint-muted text-xs">Excl. VAT</Text>
          </div>
          
          {/* Bottom Section - Fixed Height */}
          <div className="flex items-center justify-between mt-auto pt-2 border-t border-pharmint-border/50">
            <div className="flex items-center gap-2">
              <span
                className={clx("text-sm", {
                  "text-green-400": inventoryQuantity && inventoryQuantity > 50,
                  "text-yellow-400":
                    inventoryQuantity &&
                    inventoryQuantity <= 50 &&
                    inventoryQuantity > 0,
                  "text-accent": inventoryQuantity === 0,
                })}
              >
                •
              </span>
              <Text className="text-pharmint-muted text-xs">
                {inventoryQuantity} left
              </Text>
            </div>
            <PreviewAddToCart product={product} region={region} />
          </div>
        </div>
      </div>
    </LocalizedClientLink>
  )
}
