import { clearExpiredToken } from "../../actions/auth"

export async function POST() {
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