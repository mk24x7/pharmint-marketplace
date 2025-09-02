import { listCategories } from "@/lib/data/categories"
import { listCollections } from "@/lib/data/collections"
import { Text, clx } from "@medusajs/ui"

import LocalizedClientLink from "@/modules/common/components/localized-client-link"

export default async function Footer() {
  const { collections } = await listCollections({
    offset: "0",
    limit: "12",
  })
  const product_categories = await listCategories({
    offset: 0,
    limit: 6,
  })

  // Show all collections in prioritized order
  const priorityCollections = [
    "featured",
    "new-arrivals", 
    "best-sellers",
    "essential-medicines",
    "bulk-order-specials",
    "fast-moving-items",
    "specialty-pharmaceuticals",
    "generic-alternatives",
    "regulatory-compliance"
  ]

  const orderedCollections = priorityCollections
    .map(handle => collections?.find(c => c.handle === handle))
    .filter(Boolean)
    .concat(
      collections?.filter(c => !priorityCollections.includes(c.handle || "")) || []
    )

  return (
    <footer className="border-t border-pharmint-border bg-background w-full">
      <div className="content-container flex flex-col w-full">
        <div className="flex flex-col gap-y-6 xsmall:flex-row items-start justify-between py-40">
          <div>
            <LocalizedClientLink
              href="/"
              className="hover:text-accent transition-colors duration-200 flex items-center w-fit"
            >
              <h1 className="small:text-base text-sm font-medium flex items-center">
                <img 
                  src="/logo-dark.png" 
                  alt="Pharmint Logo" 
                  className="inline mr-2 h-8 w-8 object-contain"
                />
                <span className="font-bold text-white">Pharmint</span>
                <span className="ml-1 text-accent font-medium">.PH</span>
              </h1>
            </LocalizedClientLink>
          </div>
          <div className="text-small-regular gap-8 md:gap-12 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3">
            {product_categories && product_categories?.length > 0 && (
              <div className="flex flex-col gap-y-3">
                <span className="txt-small-plus text-white">
                  Categories
                </span>
                <ul
                  className="grid grid-cols-1 gap-y-2"
                  data-testid="footer-categories"
                >
                  {product_categories?.slice(0, 6).map((c) => {
                    if (c.parent_category) {
                      return
                    }

                    const children =
                      c.category_children?.map((child) => ({
                        name: child.name,
                        handle: child.handle,
                        id: child.id,
                      })) || null

                    return (
                      <li
                        className="flex flex-col gap-y-1 text-pharmint-muted txt-small"
                        key={c.id}
                      >
                        <LocalizedClientLink
                          className={clx(
                            "hover:text-accent transition-colors",
                            children && "txt-small-plus"
                          )}
                          href={`/categories/${c.handle}`}
                          data-testid="category-link"
                        >
                          {c.name}
                        </LocalizedClientLink>
                        {children && (
                          <ul className="grid grid-cols-1 ml-3 gap-y-1">
                            {children &&
                              children.map((child) => (
                                <li key={child.id}>
                                  <LocalizedClientLink
                                    className="hover:text-accent transition-colors"
                                    href={`/categories/${child.handle}`}
                                    data-testid="category-link"
                                  >
                                    {child.name}
                                  </LocalizedClientLink>
                                </li>
                              ))}
                          </ul>
                        )}
                      </li>
                    )
                  })}
                </ul>
              </div>
            )}
            {orderedCollections && orderedCollections.length > 0 && (
              <div className="flex flex-col gap-y-3">
                <span className="txt-small-plus text-white">
                  Collections
                </span>
                <ul className="grid grid-cols-1 gap-y-2 text-pharmint-muted txt-small">
                  {orderedCollections.map((c) => (
                    <li key={c.id}>
                      <LocalizedClientLink
                        className="hover:text-accent transition-colors"
                        href={`/collections/${c.handle}`}
                      >
                        {c.title}
                      </LocalizedClientLink>
                    </li>
                  ))}
                </ul>
              </div>
            )}
            <div className="flex flex-col gap-y-3">
              <span className="txt-small-plus text-white">Pharmint</span>
              <ul className="grid grid-cols-1 gap-y-2 text-pharmint-muted txt-small">
                <li>
                  <a
                    href="https://github.com/medusajs"
                    target="_blank"
                    rel="noreferrer"
                    className="hover:text-accent transition-colors"
                  >
                    GitHub
                  </a>
                </li>
                <li>
                  <a
                    href="https://docs.medusajs.com"
                    target="_blank"
                    rel="noreferrer"
                    className="hover:text-accent transition-colors"
                  >
                    Documentation
                  </a>
                </li>
                <li>
                  <a
                    href="https://github.com/medusajs/b2b-starter-medusa"
                    target="_blank"
                    rel="noreferrer"
                    className="hover:text-accent transition-colors"
                  >
                    Source code
                  </a>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div className="flex w-full mb-16 justify-center text-pharmint-muted">
          <Text className="txt-compact-small">
            © {new Date().getFullYear()}{" "}
            <a 
              href="https://pharmint.com" 
              target="_blank" 
              rel="noopener noreferrer"
              className="hover:text-accent transition-colors"
            >
              Pharmint
            </a>
            . All rights reserved.
          </Text>
        </div>
      </div>
    </footer>
  )
}
