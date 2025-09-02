import { sdk } from "@/lib/config"

export interface SearchResult {
  id: string
  title: string
  description?: string
  handle: string
  thumbnail?: string
  categories: string[]
  collection_handle?: string
  variants: {
    id: string
    title: string
    sku?: string
    prices: {
      currency_code: string
      amount: number
    }[]
  }[]
  tags: string[]
  status: string
}

export interface SearchResponse {
  products: SearchResult[]
  count: number
  offset: number
  limit: number
}

export async function searchProducts(
  query: string,
  limit: number = 20,
  offset: number = 0
): Promise<SearchResponse> {
  try {
    const response = await fetch(`${process.env.NEXT_PUBLIC_MEDUSA_BACKEND_URL}/store/search`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-publishable-api-key": process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY || "",
      },
      body: JSON.stringify({
        query,
        limit,
        offset,
      }),
    })

    if (!response.ok) {
      throw new Error("Search request failed")
    }

    return await response.json()
  } catch (error) {
    console.error("Search error:", error)
    return {
      products: [],
      count: 0,
      offset,
      limit,
    }
  }
}