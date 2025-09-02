"use server"

import { sdk } from "@/lib/config"
import medusaError from "@/lib/util/medusa-error"
import { HttpTypes } from "@medusajs/types"
import { getCacheOptions, getAuthHeaders } from "./cookies"

export const listRegions = async (): Promise<HttpTypes.StoreRegion[]> => {
  const headers = {
    ...(await getAuthHeaders()),
  }

  const next = {
    ...(await getCacheOptions("regions")),
  }

  return sdk.client
    .fetch<{ regions: HttpTypes.StoreRegion[] }>(`/store/regions`, {
      credentials: "include",
      method: "GET",
      headers,
      next,
      cache: "force-cache",
    })
    .then(({ regions }: { regions: HttpTypes.StoreRegion[] }) => regions)
    .catch(medusaError)
}

export const retrieveRegion = async (
  id: string
): Promise<HttpTypes.StoreRegion> => {
  const headers = {
    ...(await getAuthHeaders()),
  }

  const next = {
    ...(await getCacheOptions(["regions", id].join("-"))),
  }

  return sdk.client
    .fetch<{ region: HttpTypes.StoreRegion }>(`/store/regions/${id}`, {
      credentials: "include",
      method: "GET",
      headers,
      next,
      cache: "force-cache",
    })
    .then(({ region }: { region: HttpTypes.StoreRegion }) => region)
    .catch(medusaError)
}

const regionMap = new Map<string, HttpTypes.StoreRegion>()

export const getRegion = async (
  countryCode?: string
): Promise<HttpTypes.StoreRegion | null> => {
  try {
    const lookupCode = countryCode || "us"
    
    if (regionMap.has(lookupCode)) {
      return regionMap.get(lookupCode) ?? null
    }

    const regions = await listRegions()

    if (!regions) {
      return null
    }

    regions.forEach((region) => {
      region.countries?.forEach((c) => {
        regionMap.set(c?.iso_2 ?? "", region)
      })
    })

    const region = regionMap.get(lookupCode)

    return region ?? null
  } catch (e: any) {
    return null
  }
}

export const getDefaultRegion = async (): Promise<HttpTypes.StoreRegion | null> => {
  return getRegion("us")
}
