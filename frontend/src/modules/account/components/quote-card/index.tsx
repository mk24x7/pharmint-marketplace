import { convertToLocale } from "@lib/util/money"
import { Container } from "@medusajs/ui"
import { StoreQuoteResponse } from "@/types/quote"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

interface QuoteCardProps {
  quote: StoreQuoteResponse["quote"]
}

const QuoteCard = ({ quote }: QuoteCardProps) => {
  const getStatusColor = (status: string) => {
    switch (status) {
      case "pending_merchant":
        return "text-yellow-600"
      case "pending_customer":
        return "text-blue-600"
      case "accepted":
        return "text-green-600"
      case "customer_rejected":
      case "merchant_rejected":
        return "text-red-600"
      default:
        return "text-gray-600"
    }
  }

  const formatStatus = (status: string) => {
    return status.replace(/_/g, " ").replace(/\b\w/g, l => l.toUpperCase())
  }

  return (
    <Container className="p-6 border rounded-lg">
      <div className="flex justify-between items-start mb-4">
        <div>
          <h3 className="text-lg font-semibold">
            Quote #{quote.draft_order?.display_id}
          </h3>
          <p className="text-sm text-ui-fg-muted">
            {new Date(quote.created_at).toLocaleDateString()}
          </p>
        </div>
        <span className={`text-sm font-medium ${getStatusColor(quote.status)}`}>
          {formatStatus(quote.status)}
        </span>
      </div>

      <div className="mb-4">
        <p className="text-sm text-ui-fg-subtle">
          {quote.draft_order?.items?.length || 0} items
        </p>
        <p className="text-lg font-semibold">
          {convertToLocale({
            amount: (quote.draft_order?.total || 0) / 100,
            currency_code: quote.draft_order?.currency_code || "USD"
          })}
        </p>
      </div>

      <LocalizedClientLink
        href={`/account/quotes/details/${quote.id}`}
        className="text-sm text-ui-fg-interactive hover:underline"
      >
        View Details →
      </LocalizedClientLink>
    </Container>
  )
}

export default QuoteCard