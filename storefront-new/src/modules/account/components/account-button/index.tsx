"use client"

import LocalizedClientLink from "@/modules/common/components/localized-client-link"
import User from "@/modules/common/icons/user"
import { B2BCustomer } from "@/types/global"
import { usePathname } from "next/navigation"
import { clx } from "@medusajs/ui"

export default function AccountButton({
  customer,
}: {
  customer: B2BCustomer | null
}) {
  const pathname = usePathname()
  const isAccountPage = pathname?.includes('/account')

  return (
    <LocalizedClientLink 
      className="hover:text-accent transition-colors duration-200 group" 
      href="/account"
    >
      <button className={clx(
        "flex gap-1.5 items-center rounded-2xl bg-none shadow-none border border-transparent hover:bg-accent/20 hover:border-accent/30 active:bg-accent/30 focus:bg-accent/20 focus:border-accent/50 focus:outline-none px-2 py-1 transition-all duration-200",
        isAccountPage 
          ? "bg-accent/20 border-accent/50 text-accent" 
          : "text-white group-hover:text-accent"
      )}>
        <User />
        <span className="hidden small:inline-block">
          {customer ? customer.first_name : "Log in"}
        </span>
      </button>
    </LocalizedClientLink>
  )
}
