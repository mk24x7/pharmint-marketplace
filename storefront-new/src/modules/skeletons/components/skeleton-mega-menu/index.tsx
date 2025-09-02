import LocalizedClientLink from "@/modules/common/components/localized-client-link"

export default function SkeletonMegaMenu() {
  return (
    <LocalizedClientLink
      className="hover:text-ui-fg-base hover:bg-background-secondary rounded-full px-3 py-2"
      href="/store"
    >
      Products
    </LocalizedClientLink>
  )
}
