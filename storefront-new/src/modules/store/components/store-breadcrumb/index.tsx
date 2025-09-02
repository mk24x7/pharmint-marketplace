import LocalizedClientLink from "@/modules/common/components/localized-client-link"

const StoreBreadcrumbItem = ({
  title,
  handle,
}: {
  title: string
  handle?: string
}) => {
  return (
    <li className="text-pharmint-muted">
      <LocalizedClientLink
        className="hover:text-accent transition-colors duration-200"
        href={handle ? `${handle}` : "/store"}
      >
        {title}
      </LocalizedClientLink>
    </li>
  )
}

const StoreBreadcrumb = () => {
  return (
    <ul className="flex items-center gap-x-3 text-sm">
      <StoreBreadcrumbItem title="Products" key="base" />
      <span className="text-pharmint-muted">{">"}</span>
      <StoreBreadcrumbItem title="All products" handle="/store" />
    </ul>
  )
}

export default StoreBreadcrumb
