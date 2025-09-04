import { clearExpiredToken } from "../../actions/auth"
import { NextRequest } from "next/server"

const rateLimitMap = new Map<string, { count: number; resetTime: number }>()
const RATE_LIMIT_REQUESTS = 5
const RATE_LIMIT_WINDOW = 60 * 1000

function getRateLimitKey(request: NextRequest): string {
  const forwarded = request.headers.get("x-forwarded-for")
  const realIp = request.headers.get("x-real-ip")
  return forwarded?.split(",")[0] || realIp || "unknown"
}

function isRateLimited(key: string): boolean {
  const now = Date.now()
  const limit = rateLimitMap.get(key)
  
  if (!limit || now > limit.resetTime) {
    rateLimitMap.set(key, { count: 1, resetTime: now + RATE_LIMIT_WINDOW })
    return false
  }
  
  if (limit.count >= RATE_LIMIT_REQUESTS) {
    return true
  }
  
  limit.count++
  return false
}

export async function POST(request: NextRequest) {
  const clientKey = getRateLimitKey(request)
  
  if (isRateLimited(clientKey)) {
    return Response.json(
      { 
        success: false, 
        error: "Rate limit exceeded. Please try again later.",
        retryAfter: Math.ceil((rateLimitMap.get(clientKey)?.resetTime || 0 - Date.now()) / 1000)
      },
      { 
        status: 429,
        headers: {
          'Retry-After': String(Math.ceil((rateLimitMap.get(clientKey)?.resetTime || 0 - Date.now()) / 1000))
        }
      }
    )
  }

  try {
    const result = await clearExpiredToken()
    return Response.json(result)
  } catch (error) {
    return Response.json(
      { success: false, error: String(error) },
      { status: 500 }
    )
  }
}