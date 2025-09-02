import {
  CheckCircleSolid,
  ExclamationCircleSolid,
  InformationCircleSolid,
} from "@medusajs/icons"
import { HttpTypes } from "@medusajs/types"
import { PharmaceuticalAttributesDTO } from "@/types/pharmaceutical-attributes"

const ProductFacts = ({ product }: { product: HttpTypes.StoreProduct }) => {
  const inventoryQuantity =
    product.variants?.reduce(
      (acc, variant) => acc + (variant.inventory_quantity ?? 0),
      0
    ) || 0

  // Type assertion to access pharmaceutical_attributes
  const productWithPharma = product as HttpTypes.StoreProduct & {
    pharmaceutical_attributes?: PharmaceuticalAttributesDTO
  }

  const pharmaceuticalAttributes = productWithPharma.pharmaceutical_attributes

  return (
    <div className="flex flex-col gap-y-3 w-full">
      {/* Inventory Status */}
      {inventoryQuantity > 10 ? (
        <span className="flex items-center gap-x-2 text-pharmint-muted text-sm">
          <CheckCircleSolid className="text-green-500" /> Can be shipped
          immediately ({inventoryQuantity} in stock)
        </span>
      ) : (
        <span className="flex items-center gap-x-2 text-pharmint-muted text-sm ">
          <ExclamationCircleSolid className="text-orange-500" />
          Limited quantity available ({inventoryQuantity} in stock)
        </span>
      )}

      {/* MID Code */}
      {product.mid_code && (
        <span className="flex items-center gap-x-2 text-pharmint-muted text-sm">
          <InformationCircleSolid />
          MID: {product.mid_code}
        </span>
      )}

      {/* Quick Pharmaceutical Facts */}
      {pharmaceuticalAttributes && (
        <div className="bg-blue-50 border border-blue-200 rounded-md p-3 space-y-2">
          {pharmaceuticalAttributes.strength && (
            <span className="flex items-center gap-x-2 text-blue-700 text-sm">
              <InformationCircleSolid className="text-blue-600" />
              Strength: {pharmaceuticalAttributes.strength}
            </span>
          )}
          
          {pharmaceuticalAttributes.dosage_form && (
            <span className="flex items-center gap-x-2 text-blue-700 text-sm">
              <InformationCircleSolid className="text-blue-600" />
              Form: {pharmaceuticalAttributes.dosage_form}
            </span>
          )}
          
          {pharmaceuticalAttributes.prescription_status && (
            <span className="flex items-center gap-x-2 text-blue-700 text-sm">
              <CheckCircleSolid className={`${
                pharmaceuticalAttributes.prescription_status === 'prescription' ? 'text-red-600' :
                pharmaceuticalAttributes.prescription_status === 'controlled_substance' ? 'text-orange-600' :
                'text-green-600'
              }`} />
              {pharmaceuticalAttributes.prescription_status.replace('_', ' ').toUpperCase()}
            </span>
          )}
        </div>
      )}
    </div>
  )
}

export default ProductFacts
