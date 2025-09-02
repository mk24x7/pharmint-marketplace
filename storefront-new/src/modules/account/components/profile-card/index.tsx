"use client"

import { updateCustomer } from "@/lib/data/customer"
import Button from "@/modules/common/components/button"
import Input from "@/modules/common/components/input"
import { B2BCustomer } from "@/types/global"
import { HttpTypes } from "@medusajs/types"
import { Container, Text, clx, toast } from "@medusajs/ui"
import { useState } from "react"

const ProfileCard = ({ customer }: { customer: B2BCustomer }) => {
  const [isEditing, setIsEditing] = useState(false)
  const [isSaving, setIsSaving] = useState(false)

  const { first_name, last_name, phone } = customer

  const [customerData, setCustomerData] = useState({
    first_name,
    last_name,
    phone,
  } as HttpTypes.StoreUpdateCustomer)

  const handleSave = async () => {
    setIsSaving(true)
    await updateCustomer(customerData).catch(() => {
      toast.error("Error updating customer")
    })
    setIsSaving(false)
    setIsEditing(false)

    toast.success("Customer updated")
  }

  return (
    <div className="h-fit">
      <Container className="p-0 overflow-hidden">
        <form
          className={clx(
            "grid grid-cols-2 gap-4 border-b border-pharmint-border overflow-hidden transition-all duration-300 ease-in-out",
            {
              "max-h-[244px] opacity-100 p-4": isEditing,
              "max-h-0 opacity-0": !isEditing,
            }
          )}
          onKeyDown={(e) => {
            if (e.key === "Enter") {
              e.preventDefault()
              handleSave()
            }
          }}
        >
          <div className="flex flex-col gap-y-2">
            <Text className="font-medium text-white">First Name</Text>
            <Input
              label="First Name"
              name="first_name"
              value={customerData.first_name}
              onChange={(e) =>
                setCustomerData({
                  ...customerData,
                  first_name: e.target.value,
                })
              }
            />
          </div>
          <div className="flex flex-col gap-y-2">
            <Text className="font-medium text-white">Last Name</Text>
            <Input
              label="Last Name"
              name="last_name"
              value={customerData.last_name}
              onChange={(e) =>
                setCustomerData({
                  ...customerData,
                  last_name: e.target.value,
                })
              }
            />
          </div>
          <div className="flex flex-col gap-y-2">
            <Text className="font-medium text-white">Email</Text>
            <Text className=" text-pharmint-muted">{customer.email}</Text>
          </div>
          <div className="flex flex-col gap-y-2">
            <Text className="font-medium text-white">Phone</Text>
            <Input
              label="Phone"
              name="phone"
              value={customerData.phone}
              onChange={(e) =>
                setCustomerData({ ...customerData, phone: e.target.value })
              }
            />
          </div>
        </form>
        <div
          className={clx(
            "grid grid-cols-2 gap-4 border-b border-pharmint-border transition-all duration-300 ease-in-out",
            {
              "opacity-0 max-h-0": isEditing,
              "opacity-100 max-h-[214px] p-4": !isEditing,
            }
          )}
        >
          <div className="flex flex-col gap-y-2">
            <Text className="font-medium text-white">First Name</Text>
            <Text className=" text-pharmint-muted">{customer.first_name}</Text>
          </div>
          <div className="flex flex-col gap-y-2">
            <Text className="font-medium text-white">Last Name</Text>
            <Text className=" text-pharmint-muted">{customer.last_name}</Text>
          </div>
          <div className="flex flex-col gap-y-2">
            <Text className="font-medium text-white">Email</Text>
            <Text className=" text-pharmint-muted">{customer.email}</Text>
          </div>
          <div className="flex flex-col gap-y-2">
            <Text className="font-medium text-white">Phone</Text>
            <Text className=" text-pharmint-muted">{customer.phone}</Text>
          </div>
        </div>

        <div className="flex items-center justify-end gap-2 bg-background-secondary p-4">
          {isEditing ? (
            <>
              <Button
                variant="secondary"
                onClick={() => setIsEditing(false)}
                disabled={isSaving}
              >
                Cancel
              </Button>
              <Button
                variant="primary"
                onClick={handleSave}
                isLoading={isSaving}
              >
                Save
              </Button>
            </>
          ) : (
            <Button variant="secondary" onClick={() => setIsEditing(true)}>
              Edit
            </Button>
          )}
        </div>
      </Container>
    </div>
  )
}

export default ProfileCard
