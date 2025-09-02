"use client"

import FilePlus from "@/modules/common/icons/file-plus"
import { RequestQuoteConfirmation } from "@/modules/quotes/components/request-quote-confirmation"
import { RequestQuotePrompt } from "@/modules/quotes/components/request-quote-prompt"
import { Cart } from "@medusajs/types"
import { clx } from "@medusajs/ui"
import { usePathname } from "next/navigation"

type QuoteButtonProps = {
  hasCartWithItems: boolean
}

export const QuoteButton = ({ hasCartWithItems }: QuoteButtonProps) => {
  const pathname = usePathname()
  const isQuotePage = pathname?.includes('/quotes')

  const buttonClasses = clx(
    "flex gap-1.5 items-center rounded-2xl bg-none shadow-none border border-transparent hover:bg-accent/20 hover:border-accent/30 active:bg-accent/30 focus:bg-accent/20 focus:border-accent/50 focus:outline-none px-2 py-1 transition-all duration-200",
    isQuotePage 
      ? "bg-accent/20 border-accent/50 text-accent" 
      : "text-white hover:text-accent"
  )

  if (hasCartWithItems) {
    return (
      <RequestQuoteConfirmation>
        <button className={buttonClasses}>
          <FilePlus />
          <span className="hidden small:inline-block">Quote</span>
        </button>
      </RequestQuoteConfirmation>
    )
  }

  return (
    <RequestQuotePrompt>
      <button className={buttonClasses}>
        <FilePlus />
        <span className="hidden small:inline-block">Quote</span>
      </button>
    </RequestQuotePrompt>
  )
}