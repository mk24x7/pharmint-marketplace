import { getProductsById } from "@/lib/data/products"
import { HttpTypes } from "@medusajs/types"
import { Text } from "@medusajs/ui"

import InteractiveLink from "@/modules/common/components/interactive-link"
import ProductPreview from "@/modules/products/components/product-preview"

export default async function ProductRail({
  collection,
  region,
}: {
  collection: HttpTypes.StoreCollection
  region: HttpTypes.StoreRegion
}) {
  const { products } = collection

  if (!products) {
    return null
  }

  const productsWithPrices = await getProductsById({
    ids: products.map((p) => p.id!),
    regionId: region.id,
  })

  return (
    <div className="content-container py-12 small:py-24">
      <div className="flex justify-between mb-8">
        <Text className="text-xl font-semibold text-white">{collection.title}</Text>
        <InteractiveLink href={`/collections/${collection.handle}`} className="text-accent hover:text-accent-hover transition-colors duration-200">
          View all
        </InteractiveLink>
      </div>
      {/* Desktop Grid Layout */}
      <div className="hidden lg:grid grid-cols-4 gap-6">
        {productsWithPrices &&
          productsWithPrices.slice(0, 4).map((product) => (
            <div key={product.id} className="h-full">
              <ProductPreview product={product} region={region} isFeatured />
            </div>
          ))}
      </div>

      {/* Tablet Grid Layout */}
      <div className="hidden md:grid lg:hidden grid-cols-3 gap-6">
        {productsWithPrices &&
          productsWithPrices.slice(0, 3).map((product) => (
            <div key={product.id} className="h-full">
              <ProductPreview product={product} region={region} isFeatured />
            </div>
          ))}
      </div>

      {/* Mobile Horizontal Scroll Layout */}
      <div className="md:hidden overflow-x-auto">
        <div className="flex gap-4 pb-4" style={{ width: 'max-content' }}>
          {productsWithPrices &&
            productsWithPrices.slice(0, 6).map((product) => (
              <div key={product.id} className="min-w-[280px] flex-shrink-0">
                <ProductPreview product={product} region={region} isFeatured />
              </div>
            ))}
        </div>
      </div>
    </div>
  )
}
