import { getCollectionByHandle } from "@/lib/data/collections"
import { getProductsById } from "@/lib/data/products"
import { getRegion } from "@/lib/data/regions"
import { Text } from "@medusajs/ui"
import InteractiveLink from "@/modules/common/components/interactive-link"
import ProductPreview from "@/modules/products/components/product-preview"

interface CollectionSectionProps {
  handle: string
  countryCode: string
  title?: string
  description?: string
}

export default async function CollectionSection({
  handle,
  countryCode,
  title,
  description,
}: CollectionSectionProps) {
  const collection = await getCollectionByHandle(handle)
  const region = await getRegion(countryCode)

  if (!collection || !region) {
    return null
  }

  const { products } = collection

  if (!products || products.length === 0) {
    return null
  }

  const productsWithPrices = await getProductsById({
    ids: products.slice(0, 8).map((p) => p.id!),
    regionId: region.id,
  })

  if (!productsWithPrices || productsWithPrices.length === 0) {
    return null
  }

  return (
    <div className="bg-background py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        <div className="flex justify-between items-end mb-8">
          <div>
            <Text className="text-2xl sm:text-3xl font-bold text-white mb-2">
              {title || collection.title}
            </Text>
            {description && (
              <p className="text-pharmint-muted text-base max-w-2xl">
                {description}
              </p>
            )}
          </div>
          <InteractiveLink 
            href={`/collections/${collection.handle}`} 
            className="text-accent hover:text-accent-hover transition-colors duration-200 font-medium"
          >
            View All →
          </InteractiveLink>
        </div>
        
        <div className="overflow-x-auto">
          <div className="flex gap-6 pb-4" style={{ width: 'max-content' }}>
            {productsWithPrices.map((product) => (
              <div key={product.id} className="bg-background-secondary rounded-lg border border-pharmint-border hover:border-accent/50 transition-colors duration-300 min-w-[280px] flex-shrink-0">
                <ProductPreview product={product} region={region} isFeatured />
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}