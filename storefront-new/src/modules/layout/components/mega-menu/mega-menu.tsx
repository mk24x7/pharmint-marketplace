"use client"

import { HttpTypes } from "@medusajs/types"
import { clx } from "@medusajs/ui"
import LocalizedClientLink from "@/modules/common/components/localized-client-link"
import { usePathname } from "next/navigation"
import { useEffect, useState } from "react"

const MegaMenu = ({
  categories,
  collections,
}: {
  categories: HttpTypes.StoreProductCategory[]
  collections: HttpTypes.StoreCollection[]
}) => {
  const [isHovered, setIsHovered] = useState(false)
  const [selectedCategory, setSelectedCategory] = useState<
    HttpTypes.StoreProductCategory["id"] | null
  >(null)

  const pathname = usePathname()

  const mainCategories = categories.filter(
    (category) => !category.parent_category_id
  )

  const getSubCategories = (categoryId: string) => {
    return categories.filter(
      (category) => category.parent_category_id === categoryId
    )
  }

  let menuTimeout: NodeJS.Timeout | null = null

  const handleMenuHover = () => {
    if (menuTimeout) {
      clearTimeout(menuTimeout)
    }
    setIsHovered(true)
  }

  const handleMenuLeave = () => {
    menuTimeout = setTimeout(() => {
      setIsHovered(false)
    }, 300)

    return () => {
      if (menuTimeout) {
        clearTimeout(menuTimeout)
      }
    }
  }

  let categoryTimeout: NodeJS.Timeout | null = null

  const handleCategoryHover = (categoryId: string) => {
    categoryTimeout = setTimeout(() => {
      setSelectedCategory(categoryId)
    }, 200)

    return () => {
      if (categoryTimeout) {
        clearTimeout(categoryTimeout)
      }
    }
  }

  const handleCategoryLeave = () => {
    if (categoryTimeout) {
      clearTimeout(categoryTimeout)
    }
  }

  useEffect(() => {
    setIsHovered(false)
  }, [pathname])

  return (
    <>
      <div
        onMouseEnter={handleMenuHover}
        onMouseLeave={handleMenuLeave}
        className="z-50"
      >
        <LocalizedClientLink
          className="hover:text-accent hover:bg-accent/20 border border-transparent hover:border-accent/30 rounded-full px-3 py-2 text-white transition-all duration-200"
          href="/store"
        >
          Products
        </LocalizedClientLink>
        {isHovered && (
          <div className="fixed left-0 right-0 top-[60px] flex gap-16 py-10 px-20 bg-black border-b border-pharmint-border">
            {/* Categories Section */}
            <div className="flex flex-col gap-2 min-w-[200px]">
              <h3 className="text-accent font-semibold mb-2">Categories</h3>
              {mainCategories.map((category) => (
                <LocalizedClientLink
                  key={category.id}
                  href={`/categories/${category.handle}`}
                  className={clx(
                    "hover:bg-white/20 border border-transparent hover:border-white/30 hover:cursor-pointer rounded-full px-3 py-2 w-fit font-medium text-white transition-all duration-200",
                    selectedCategory === category.id && "bg-white/20 border-white/30"
                  )}
                  onMouseEnter={() => handleCategoryHover(category.id)}
                  onMouseLeave={handleCategoryLeave}
                >
                  {category.name}
                </LocalizedClientLink>
              ))}
            </div>

            {/* Collections Section */}
            <div className="flex flex-col gap-2 min-w-[400px]">
              <h3 className="text-accent font-semibold mb-2">Collections</h3>
              <div className="grid grid-cols-2 gap-2">
                {collections.slice(0, 8).map((collection) => (
                  <LocalizedClientLink
                    key={collection.id}
                    href={`/collections/${collection.handle}`}
                    className="hover:bg-white/20 border border-transparent hover:border-white/30 rounded-md px-3 py-2 font-medium text-white transition-all duration-200 text-sm"
                  >
                    {collection.title}
                  </LocalizedClientLink>
                ))}
              </div>
            </div>

            {/* Subcategories Section */}
            {selectedCategory && (
              <div className="grid grid-cols-3 gap-16 flex-1">
                {getSubCategories(selectedCategory).map((category) => (
                  <div key={category.id} className="flex flex-col gap-2">
                    <LocalizedClientLink
                      className="font-medium text-white hover:text-accent hover:bg-white/20 border border-transparent rounded-md px-2 py-1 transition-all duration-200"
                      href={`/categories/${category.handle}`}
                    >
                      {category.name}
                    </LocalizedClientLink>
                    <div className="flex flex-col gap-2">
                      {getSubCategories(category.id).map((subCategory) => (
                        <LocalizedClientLink
                          key={subCategory.id}
                          className="hover:text-accent hover:bg-white/15 text-pharmint-muted border border-transparent rounded-md px-2 py-1 transition-all duration-200"
                          href={`/categories/${subCategory.handle}`}
                        >
                          {subCategory.name}
                        </LocalizedClientLink>
                      ))}
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>
      {isHovered && (
        <div className="fixed inset-0 mt-[60px] blur-sm backdrop-blur-sm z-[-1]" />
      )}
    </>
  )
}

export default MegaMenu
