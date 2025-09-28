"use client"

import { useState } from "react"
import { Button } from "@medusajs/ui"
import Modal from "@modules/common/components/modal"

type PromptModalProps = {
  title: string
  description: string
  handleAction: () => void | Promise<void>
  isLoading?: boolean
  children: React.ReactNode
}

export const PromptModal = ({
  title,
  description,
  handleAction,
  isLoading = false,
  children,
}: PromptModalProps) => {
  const [isOpen, setIsOpen] = useState(false)

  const onAction = async () => {
    await handleAction()
    setIsOpen(false)
  }

  return (
    <>
      <div onClick={() => setIsOpen(true)}>{children}</div>
      <Modal isOpen={isOpen} close={() => setIsOpen(false)} size="small">
        <Modal.Title>{title}</Modal.Title>
        <Modal.Description>
          <p className="text-center">{description}</p>
        </Modal.Description>
        <Modal.Footer>
          <Button
            variant="secondary"
            onClick={() => setIsOpen(false)}
            disabled={isLoading}
          >
            Cancel
          </Button>
          <Button
            onClick={onAction}
            disabled={isLoading}
            isLoading={isLoading}
          >
            Confirm
          </Button>
        </Modal.Footer>
      </Modal>
    </>
  )
}