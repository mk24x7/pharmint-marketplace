"use client"

import { searchProducts, SearchResult } from "@/lib/data/search"
import { MagnifyingGlass, X } from "@medusajs/icons"
import { Input } from "@medusajs/ui"
import Image from "next/image"
import Link from "next/link"
import { useCallback, useEffect, useState } from "react"

interface SearchModalProps {
  isOpen: boolean
  onClose: () => void
}

const SearchModal = ({ isOpen, onClose }: SearchModalProps) => {
  const [query, setQuery] = useState("")
  const [results, setResults] = useState<SearchResult[]>([])
  const [isLoading, setIsLoading] = useState(false)
  const [selectedIndex, setSelectedIndex] = useState(-1)

  const performSearch = useCallback(async (searchQuery: string) => {
    if (!searchQuery.trim()) {
      setResults([])
      return
    }

    setIsLoading(true)
    try {
      const response = await searchProducts(searchQuery, 8)
      setResults(response.products)
    } catch (error) {
      console.error("Search failed:", error)
      setResults([])
    } finally {
      setIsLoading(false)
    }
  }, [])

  useEffect(() => {
    const timeoutId = setTimeout(() => {
      performSearch(query)
    }, 300)

    return () => clearTimeout(timeoutId)
  }, [query, performSearch])

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (!isOpen) return

      switch (e.key) {
        case "Escape":
          onClose()
          break
        case "ArrowDown":
          e.preventDefault()
          setSelectedIndex(prev => 
            prev < results.length - 1 ? prev + 1 : prev
          )
          break
        case "ArrowUp":
          e.preventDefault()
          setSelectedIndex(prev => prev > 0 ? prev - 1 : -1)
          break
        case "Enter":
          e.preventDefault()
          if (selectedIndex >= 0 && results[selectedIndex]) {
            window.location.href = `/products/${results[selectedIndex].handle}`
          }
          break
      }
    }

    document.addEventListener("keydown", handleKeyDown)
    return () => document.removeEventListener("keydown", handleKeyDown)
  }, [isOpen, onClose, results, selectedIndex])

  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = "hidden"
    } else {
      document.body.style.overflow = "unset"
      setQuery("")
      setResults([])
      setSelectedIndex(-1)
    }

    return () => {
      document.body.style.overflow = "unset"
    }
  }, [isOpen])

  if (!isOpen) return null

  return (
    <div 
      className="fixed inset-0 z-50 bg-black bg-opacity-75 backdrop-blur-sm"
      onClick={onClose}
    >
      <div className="flex items-start justify-center min-h-screen pt-16 px-4">
        <div 
          className="bg-pharmint-black border border-pharmint-border rounded-lg shadow-2xl w-full max-w-2xl"
          onClick={(e) => e.stopPropagation()}
        >
          {/* Search Header */}
          <div className="flex items-center gap-3 p-4 border-b border-pharmint-border">
            <MagnifyingGlass className="text-pharmint-muted w-5 h-5 shrink-0" />
            <div className="flex-1 min-w-0">
              <Input
                placeholder="Search for pharmaceutical products..."
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                className="w-full border-0 bg-pharmint-black text-white placeholder:text-pharmint-muted focus:ring-0 focus:outline-none pl-3 pr-0"
                autoFocus
              />
            </div>
            <button
              onClick={onClose}
              className="text-pharmint-muted hover:text-white transition-colors p-1 shrink-0"
            >
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Search Results */}
          <div className="max-h-96 overflow-y-auto">
            {isLoading ? (
              <div className="flex items-center justify-center py-8">
                <div className="animate-spin rounded-full h-6 w-6 border-2 border-accent border-t-transparent"></div>
                <span className="ml-2 text-pharmint-muted">Searching...</span>
              </div>
            ) : results.length > 0 ? (
              <div className="py-2">
                {results.map((product, index) => (
                  <Link
                    key={product.id}
                    href={`/products/${product.handle}`}
                    onClick={onClose}
                    className={`flex items-center gap-3 p-3 mx-2 rounded-lg transition-colors border ${
                      selectedIndex === index
                        ? "bg-accent/20 border-accent/40 shadow-lg"
                        : "hover:bg-background-secondary border-transparent hover:border-pharmint-border"
                    }`}
                  >
                    <div className="w-12 h-12 bg-background-secondary rounded-lg flex items-center justify-center overflow-hidden border border-pharmint-border/50">
                      {product.thumbnail ? (
                        <Image
                          src={product.thumbnail}
                          alt={product.title}
                          width={48}
                          height={48}
                          className="object-cover w-full h-full"
                        />
                      ) : (
                        <div className="w-8 h-8 bg-pharmint-border rounded"></div>
                      )}
                    </div>
                    <div className="flex-1 min-w-0">
                      <h3 className="font-medium text-white truncate">
                        {product.title}
                      </h3>
                      <p className="text-sm text-pharmint-muted truncate">
                        {product.description}
                      </p>
                      {product.variants.length > 0 && product.variants[0].prices.length > 0 && (
                        <p className="text-sm text-accent font-medium">
                          {product.variants[0].prices[0].currency_code.toUpperCase()} {
                            (product.variants[0].prices[0].amount / 100).toFixed(2)
                          }
                        </p>
                      )}
                    </div>
                  </Link>
                ))}
              </div>
            ) : query.trim() && !isLoading ? (
              <div className="flex flex-col items-center justify-center py-8 text-pharmint-muted">
                <MagnifyingGlass className="w-12 h-12 mb-4 opacity-50" />
                <p className="text-lg font-medium">No products found</p>
                <p className="text-sm">Try adjusting your search terms</p>
              </div>
            ) : (
              <div className="flex flex-col items-center justify-center py-8 text-pharmint-muted">
                <MagnifyingGlass className="w-12 h-12 mb-4 opacity-50" />
                <p className="text-lg font-medium">Search Products</p>
                <p className="text-sm">Start typing to find pharmaceutical products</p>
              </div>
            )}
          </div>

          {/* Search Footer */}
          <div className="flex items-center justify-between p-3 border-t border-pharmint-border text-xs text-pharmint-muted">
            <div className="flex gap-4">
              <span>↑↓ Navigate</span>
              <span>⏎ Select</span>
              <span>Esc Close</span>
            </div>
            <div className="flex items-center gap-1">
              Powered by <span className="text-accent font-medium">Algolia</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default SearchModal