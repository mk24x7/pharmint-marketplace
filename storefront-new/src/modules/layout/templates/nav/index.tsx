import { retrieveCart } from "@/lib/data/cart"
import { retrieveCustomer } from "@/lib/data/customer"
import AccountButton from "@/modules/account/components/account-button"
import CartButton from "@/modules/cart/components/cart-button"
import LocalizedClientLink from "@/modules/common/components/localized-client-link"
import LogoIcon from "@/modules/common/icons/logo"
import { MegaMenuWrapper } from "@/modules/layout/components/mega-menu"
import SearchButton from "@/modules/layout/components/search-button"
import { QuoteButton } from "@/modules/quotes/components/quote-button"
import SkeletonAccountButton from "@/modules/skeletons/components/skeleton-account-button"
import SkeletonCartButton from "@/modules/skeletons/components/skeleton-cart-button"
import SkeletonMegaMenu from "@/modules/skeletons/components/skeleton-mega-menu"
import { Suspense } from "react"

export async function NavigationHeader() {
  const customer = await retrieveCustomer().catch(() => null)
  const cart = await retrieveCart()

  return (
    <div className="sticky top-0 inset-x-0 bg-background/95 backdrop-blur-sm text-pharmint-white small:p-4 p-2 text-sm border-b duration-200 border-pharmint-border z-50">
      <header className="flex w-full content-container relative small:mx-auto justify-between">
        <div className="small:mx-auto flex justify-between items-center min-w-full">
          <div className="flex items-center small:space-x-4">
            <LocalizedClientLink
              className="hover:text-accent transition-colors duration-200 flex items-center w-fit"
              href="/"
            >
              <h1 className="small:text-base text-sm font-medium flex items-center">
                <img 
                  src="/logo-dark.png" 
                  alt="Pharmint Logo" 
                  className="inline mr-2 h-8 w-8 object-contain"
                />
                <span className="font-bold">Pharmint</span>
                <span className="ml-1 text-accent font-medium">.PH</span>
              </h1>
            </LocalizedClientLink>

            <nav>
              <ul className="space-x-4 hidden small:flex">
                <li>
                  <Suspense fallback={<SkeletonMegaMenu />}>
                    <MegaMenuWrapper />
                  </Suspense>
                </li>
              </ul>
            </nav>
          </div>
          <div className="flex justify-end items-center gap-2">
            <div className="relative mr-2 hidden small:inline-flex">
              <SearchButton />
            </div>

            <div className="h-4 w-px bg-pharmint-border" />

            <QuoteButton hasCartWithItems={!!(customer && cart?.items && cart.items.length > 0)} />

            <Suspense fallback={<SkeletonAccountButton />}>
              <AccountButton customer={customer} />
            </Suspense>

            <Suspense fallback={<SkeletonCartButton />}>
              <CartButton />
            </Suspense>
          </div>
        </div>
      </header>
    </div>
  )
}
