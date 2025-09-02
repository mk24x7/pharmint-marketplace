import algoliasearch from "algoliasearch"

// For frontend search, you would typically use Algolia's search-only API key
// This should be different from the admin API key used in the backend
export const searchClient = algoliasearch(
  process.env.NEXT_PUBLIC_ALGOLIA_APP_ID!,
  process.env.NEXT_PUBLIC_ALGOLIA_SEARCH_API_KEY!
)

export const ALGOLIA_PRODUCT_INDEX_NAME = process.env.NEXT_PUBLIC_ALGOLIA_PRODUCT_INDEX_NAME || 'products'