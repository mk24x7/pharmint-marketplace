"use server"

import { getCacheOptions, getAuthHeaders } from "./cookies"
import { sdk } from "@/lib/config"
import { HttpTypes } from "@medusajs/types"

export const retrieveCollection = async (id: string) => {
  const headers = {
    ...(await getAuthHeaders()),
  }

  const next = {
    ...(await getCacheOptions("collections")),
  }

  return await sdk.client
    .fetch<{ collection: HttpTypes.StoreCollection }>(
      `/store/collections/${id}`,
      {
        headers,
        next,
        cache: "force-cache",
      }
    )
    .then(({ collection }) => collection)
}

export const listCollections = async (
  query?: Record<string, any>
): Promise<HttpTypes.StoreCollection[]> => {
  const headers = {
    ...(await getAuthHeaders()),
  }

  const next = {
    ...(await getCacheOptions("collections")),
  }

  const limit = query?.limit || 100

  return sdk.client
    .fetch<{ collections: HttpTypes.StoreCollection[] }>(
      "/store/collections",
      {
        query: {
          limit,
          ...query,
        },
        headers,
        next,
        cache: "force-cache",
      }
    )
    .then(({ collections }) => collections)
}

export const getCollectionByHandle = async (
  handle: string
): Promise<HttpTypes.StoreCollection> => {
  const headers = {
    ...(await getAuthHeaders()),
  }

  const next = {
    ...(await getCacheOptions("collections")),
  }

  return sdk.client
    .fetch<{ collections: HttpTypes.StoreCollection[] }>(`/store/collections`, {
      query: {
        handle,
      },
      headers,
      next,
      cache: "force-cache",
    })
    .then(({ collections }) => collections[0])
}
