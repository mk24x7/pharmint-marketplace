import { listCategories } from "@/lib/data/categories"
import { listCollections } from "@/lib/data/collections"
import MegaMenu from "./mega-menu"

export async function MegaMenuWrapper() {
  const categories = await listCategories().catch(() => [])
  const { collections } = await listCollections({ limit: "50" }).catch(() => ({ collections: [] }))

  return <MegaMenu categories={categories} collections={collections || []} />
}

export default MegaMenuWrapper
