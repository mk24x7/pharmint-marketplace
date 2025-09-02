"use client"

import { Text } from "@medusajs/ui"

import { checkSpendingLimit } from "@/lib/util/check-spending-limit"
import PaymentButton from "@/modules/checkout/components/payment-button"
import Button from "@/modules/common/components/button"
import LocalizedClientLink from "@/modules/common/components/localized-client-link"
import { B2BCart, B2BCustomer } from "@/types"
import { ExclamationCircle } from "@medusajs/icons"

const Review = ({
  cart,
  customer,
}: {
  cart: B2BCart
  customer: B2BCustomer | null
}) => {
  const spendLimitExceeded = customer
    ? checkSpendingLimit(cart, customer)
    : false

  return (
    <div className="flex flex-col gap-y-2">
      <div className="flex items-start gap-x-1 w-full">
        <Text className="txt-xsmall text-pharmint-muted mb-1">
          By Completing this order, I agree to Medusa&apos;s{" "}
          <LocalizedClientLink
            href="/terms-of-sale"
            className="hover:text-accent"
            target="_blank"
          >
            Terms of Sale ↗
          </LocalizedClientLink>{" "}
          and{" "}
          <LocalizedClientLink
            href="/privacy-policy"
            className="hover:text-accent"
            target="_blank"
          >
            Privacy Policy ↗
          </LocalizedClientLink>
        </Text>
      </div>
      {spendLimitExceeded ? (
        <>
          <div className="flex items-center gap-x-2 bg-background-secondary border border-pharmint-border p-3 rounded-md">
            <ExclamationCircle className="text-orange-500 w-fit overflow-visible" />
            <p className="text-white text-xs">
              This order exceeds your spending limit.
              <br />
              Please contact your manager for approval.
            </p>
          </div>
          <Button className="w-full h-10 rounded-full shadow-none" disabled>
            Place Order
          </Button>
        </>
      ) : (
        <PaymentButton cart={cart} data-testid="submit-order-button" />
      )}
    </div>
  )
}

export default Review
