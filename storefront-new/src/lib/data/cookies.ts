import "server-only"

import { cookies as nextCookies } from "next/headers"

export const getAuthHeaders = async (): Promise<
  { authorization?: string; "x-publishable-api-key"?: string } | {}
> => {
  try {
    const cookies = await nextCookies()
    const token = cookies.get("_medusa_jwt")?.value
    const headers: Record<string, string> = {}

    // Add JWT authorization if available
    if (token) {
      headers.authorization = `Bearer ${token}`
    }

    // Always add publishable API key if available
    if (process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY) {
      headers["x-publishable-api-key"] = process.env.NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY
    }

    return headers
  } catch (error) {
    return {}
  }
}

export const getCacheOptions = async (
  cacheKey: string
): Promise<{ tags: string[] }> => {
  try {
    const cookies = await nextCookies()
    const cacheId = cookies.get("_medusa_cache_id")?.value

    return {
      tags: [`${cacheKey}-${cacheId}`],
    }
  } catch (error) {
    return {
      tags: [],
    }
  }
}

export const getCacheTag = (cacheKey: string) => {
  return `${cacheKey}`
}

export const getCartId = async (): Promise<string | undefined> => {
  try {
    const cookies = await nextCookies()
    return cookies.get("_medusa_cart_id")?.value
  } catch (error) {
    return undefined
  }
}

export const setCartId = async (cartId: string) => {
  try {
    const cookies = await nextCookies()
    cookies.set("_medusa_cart_id", cartId, {
      maxAge: 60 * 60 * 24 * 7, // 1 week
      httpOnly: true,
      sameSite: "strict",
      secure: process.env.NODE_ENV === "production",
    })
  } catch (error) {
    console.error("Failed to set cart ID:", error)
  }
}

export const removeCartId = async () => {
  try {
    const cookies = await nextCookies()
    cookies.delete("_medusa_cart_id")
  } catch (error) {
    console.error("Failed to remove cart ID:", error)
  }
}

export const setAuthToken = async (token: string) => {
  try {
    const cookies = await nextCookies()
    cookies.set("_medusa_jwt", token, {
      maxAge: 60 * 60 * 24 * 7, // 1 week
      httpOnly: true,
      sameSite: "strict",
      secure: process.env.NODE_ENV === "production",
    })
  } catch (error) {
    console.error("Failed to set auth token:", error)
  }
}

export const removeAuthToken = async () => {
  try {
    const cookies = await nextCookies()
    cookies.delete("_medusa_jwt")
  } catch (error) {
    console.error("Failed to remove auth token:", error)
  }
}
