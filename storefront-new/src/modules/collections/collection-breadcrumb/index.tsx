import LocalizedClientLink from "@/modules/common/components/localized-client-link"
import { HttpTypes } from "@medusajs/types"

const CollectionBreadcrumbItem = ({
  title,
  handle,
}: {
  title: string
  handle?: string
}) => {
  return (
    <li className="text-pharmint-muted">
      <LocalizedClientLink
        className="hover:text-accent"
        href={handle ? `/collections/${handle}` : "/store"}
      >
        {title}
      </LocalizedClientLink>
    </li>
  )
}

const CollectionBreadcrumb = ({
  collection,
}: {
  collection: HttpTypes.StoreCollection
}) => {
  return (
    <ul className="flex items-center gap-x-3 text-sm">
      <CollectionBreadcrumbItem title="Products" key="base" />
      <span className="text-pharmint-muted">{">"}</span>
      <CollectionBreadcrumbItem
        title={collection.title}
        handle={collection.handle}
        key={collection.id}
      />
    </ul>
  )
}

export default CollectionBreadcrumb
