"use server"

import { getCacheOptions, getAuthHeaders } from "./cookies"
import { sdk } from "@/lib/config"
import { HttpTypes } from "@medusajs/types"

export const listCategories = async (
  query?: Record<string, any>
): Promise<HttpTypes.StoreProductCategory[]> => {
  const headers = {
    ...(await getAuthHeaders()),
  }

  const next = {
    ...(await getCacheOptions("categories")),
  }

  const limit = query?.limit || 100

  return sdk.client
    .fetch<{ product_categories: HttpTypes.StoreProductCategory[] }>(
      "/store/product-categories",
      {
        query: {
          fields:
            "*category_children, *products, *parent_category, *parent_category.parent_category",
          limit,
          ...query,
        },
        headers,
        next,
        cache: "force-cache",
      }
    )
    .then(({ product_categories }) => product_categories)
}

export const getCategoriesList = async (
  limit: number = 6,
  handle?: string
): Promise<HttpTypes.StoreProductCategoryListResponse> => {
  const headers = {
    ...(await getAuthHeaders()),
  }

  const next = {
    ...(await getCacheOptions("categories")),
  }

  return sdk.client
    .fetch<HttpTypes.StoreProductCategoryListResponse>(
      `/store/product-categories`,
      {
        query: {
          fields: "*category_children, *products",
          handle,
        },
        headers,
        next,
        cache: "force-cache",
      }
    )
}

export const getCategoryByHandle = async (
  categoryHandle: string[]
): Promise<{ product_categories: HttpTypes.StoreProductCategory[] }> => {
  const headers = {
    ...(await getAuthHeaders()),
  }

  const next = {
    ...(await getCacheOptions("categories")),
  }

  const handle = categoryHandle.join("/")

  return sdk.client.fetch<{
    product_categories: HttpTypes.StoreProductCategory[]
  }>(`/store/product-categories`, {
    query: {
      fields: "*category_children, *products",
      handle,
    },
    headers,
    next,
    cache: "force-cache",
  })
}
