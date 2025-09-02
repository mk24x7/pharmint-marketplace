"use client"

import SearchModal from "@/modules/layout/components/search-modal"
import { MagnifyingGlass } from "@medusajs/icons"
import { useEffect, useState } from "react"

const SearchButton = () => {
  const [isModalOpen, setIsModalOpen] = useState(false)

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if ((e.metaKey || e.ctrlKey) && e.key === "k") {
        e.preventDefault()
        setIsModalOpen(true)
      }
    }

    document.addEventListener("keydown", handleKeyDown)
    return () => document.removeEventListener("keydown", handleKeyDown)
  }, [])

  return (
    <>
      <button
        onClick={() => setIsModalOpen(true)}
        className="flex items-center gap-2 bg-pharmint-black border border-pharmint-border px-4 py-2 rounded-full hover:border-accent/60 hover:bg-background-secondary hover:shadow-lg transition-all duration-200 group"
        title="Search for pharmaceutical products"
      >
        <MagnifyingGlass className="w-4 h-4 text-pharmint-muted group-hover:text-accent transition-colors" />
        <span className="text-sm text-pharmint-muted group-hover:text-white transition-colors hidden sm:inline">
          Search for products
        </span>
        <kbd className="hidden lg:inline-flex items-center gap-1 text-xs text-pharmint-muted bg-background-secondary px-1.5 py-0.5 rounded border border-pharmint-border/50 group-hover:bg-pharmint-black group-hover:border-pharmint-border transition-colors">
          ⌘K
        </kbd>
      </button>

      <SearchModal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} />
    </>
  )
}

export default SearchButton