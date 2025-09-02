import { listCollections } from "@/lib/data/collections"
import { getRegion } from "@/lib/data/regions"
import ProductRail from "@/modules/home/components/featured-products/product-rail"

export default async function FeaturedProducts({
  countryCode,
}: {
  countryCode: string
}) {
  const { collections } = await listCollections({
    limit: "50",
    fields: "*products",
  })
  const region = await getRegion(countryCode)

  if (!collections || !region) {
    return null
  }

  // Find the specific "Featured" collection
  const featuredCollection = collections.find(c => c.handle === "featured")

  if (!featuredCollection) {
    return null
  }

  return (
    <div className="bg-background py-16 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-12">
          <h2 className="text-3xl sm:text-4xl font-bold text-white mb-4">
            Featured Products
          </h2>
          <p className="text-pharmint-muted text-lg max-w-2xl mx-auto">
            Discover our curated selection of top pharmaceutical products and medical supplies
          </p>
        </div>
        
        <div className="bg-background-secondary rounded-lg border border-pharmint-border p-6 hover:border-accent/50 transition-colors duration-300">
          <ProductRail collection={featuredCollection} region={region} />
        </div>
      </div>
    </div>
  )
}
