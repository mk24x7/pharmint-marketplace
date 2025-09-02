"use client"

import LocalizedClientLink from "@/modules/common/components/localized-client-link"
import { XCircle } from "@medusajs/icons"
import * as Dialog from "@radix-ui/react-dialog"

export const RequestQuotePrompt = ({
  children,
}: {
  children: React.ReactNode
}) => (
  <Dialog.Root>
    <Dialog.Trigger asChild>{children}</Dialog.Trigger>

    <Dialog.Portal>
      <Dialog.Overlay className="bg-black/50 data-[state=open]:animate-overlayShow fixed inset-0 z-[75]" />
      <Dialog.Content className="z-[100] data-[state=open]:animate-contentShow fixed top-[50%] left-[50%] max-h-[85vh] w-[90vw] max-w-[450px] translate-x-[-50%] translate-y-[-50%] rounded-[6px] bg-background border border-pharmint-border p-[25px] shadow-lg focus:outline-none txt-compact-medium">
        <Dialog.Title className="flex justify-between font-sans font-medium h2-core text-white">
          Request a quote
          <Dialog.Close asChild>
            <XCircle className="text-pharmint-muted hover:text-accent focus:text-accent inline-flex appearance-none items-center justify-center rounded-full focus:shadow-[0_0_0_2px] focus:shadow-accent outline-none cursor-pointer" />
          </Dialog.Close>
        </Dialog.Title>

        <div className="p-1 text-pharmint-white">
          <ol className="list-decimal ml-8 my-5">
            <li>
              <Dialog.Close asChild>
                <LocalizedClientLink
                  className="text-accent hover:text-accent-hover cursor-pointer transition-colors duration-200"
                  href="/account"
                >
                  Log in
                </LocalizedClientLink>
              </Dialog.Close>
              {" or "}
              <Dialog.Close>
                <LocalizedClientLink
                  className="text-accent hover:text-accent-hover cursor-pointer transition-colors duration-200"
                  href="/account"
                >
                  create an account
                </LocalizedClientLink>
              </Dialog.Close>
            </li>
            <li>Add products to your cart</li>
            <li>
              Open cart & click {'"'}Request a quote{'"'}
            </li>
          </ol>

          <p>We will then get back to you as soon as possible over email</p>
        </div>
      </Dialog.Content>
    </Dialog.Portal>
  </Dialog.Root>
)
