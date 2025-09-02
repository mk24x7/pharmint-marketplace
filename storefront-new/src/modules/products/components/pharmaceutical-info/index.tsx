import { HttpTypes } from "@medusajs/types"
import { Table, Text, Badge } from "@medusajs/ui"
import { PharmaceuticalAttributesDTO } from "@/types/pharmaceutical-attributes"
import { 
  ExclamationCircle, 
  InformationCircleSolid,
  CheckCircleSolid 
} from "@medusajs/icons"

type PharmaceuticalInfoProps = {
  product: HttpTypes.StoreProduct
  pharmaceuticalAttributes?: PharmaceuticalAttributesDTO
}

const PharmaceuticalInfo = ({ product, pharmaceuticalAttributes }: PharmaceuticalInfoProps) => {
  if (!pharmaceuticalAttributes) {
    return (
      <div className="text-center py-8">
        <Text className="text-ui-fg-subtle">
          No pharmaceutical information available for this product
        </Text>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Drug Facts Panel */}
      <DrugFactsPanel attributes={pharmaceuticalAttributes} />
      
      {/* Therapeutic Information */}
      <TherapeuticInfoSection attributes={pharmaceuticalAttributes} />
      
      {/* Safety Information */}
      <SafetyInfoSection attributes={pharmaceuticalAttributes} />
      
      {/* Storage and Packaging */}
      <StoragePackagingSection attributes={pharmaceuticalAttributes} />
    </div>
  )
}

const DrugFactsPanel = ({ attributes }: { attributes: PharmaceuticalAttributesDTO }) => {
  const getPrescriptionStatusVariant = (status?: string) => {
    switch (status) {
      case "prescription":
        return "red"
      case "controlled_substance":
        return "orange"
      case "over_the_counter":
        return "green"
      default:
        return "grey"
    }
  }

  return (
    <div className="bg-white border-2 border-gray-800 rounded-lg p-6">
      <div className="border-b-2 border-gray-800 pb-2 mb-4">
        <Text className="text-xl font-bold text-gray-900">Drug Facts</Text>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {attributes.active_ingredient && (
          <div>
            <Text className="font-semibold text-gray-700 text-sm uppercase tracking-wide">
              Active Ingredient
            </Text>
            <Text className="text-gray-900 font-medium">
              {attributes.active_ingredient}
            </Text>
          </div>
        )}
        
        {attributes.strength && (
          <div>
            <Text className="font-semibold text-gray-700 text-sm uppercase tracking-wide">
              Strength
            </Text>
            <Text className="text-gray-900 font-medium">
              {attributes.strength}
            </Text>
          </div>
        )}
        
        {attributes.dosage_form && (
          <div>
            <Text className="font-semibold text-gray-700 text-sm uppercase tracking-wide">
              Dosage Form
            </Text>
            <Text className="text-gray-900 font-medium capitalize">
              {attributes.dosage_form}
            </Text>
          </div>
        )}
        
        {attributes.route_of_administration && (
          <div>
            <Text className="font-semibold text-gray-700 text-sm uppercase tracking-wide">
              Route of Administration
            </Text>
            <Text className="text-gray-900 font-medium capitalize">
              {attributes.route_of_administration}
            </Text>
          </div>
        )}
      </div>
      
      {attributes.prescription_status && (
        <div className="mt-4 pt-4 border-t border-gray-200">
          <Badge variant={getPrescriptionStatusVariant(attributes.prescription_status)}>
            {attributes.prescription_status.replace('_', ' ').toUpperCase()}
          </Badge>
        </div>
      )}
    </div>
  )
}

const TherapeuticInfoSection = ({ attributes }: { attributes: PharmaceuticalAttributesDTO }) => {
  return (
    <div className="bg-blue-50 border border-blue-200 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-4">
        <InformationCircleSolid className="text-blue-600" />
        <Text className="text-lg font-semibold text-blue-900">
          Therapeutic Information
        </Text>
      </div>
      
      <Table>
        <Table.Body>
          {attributes.generic_name && (
            <Table.Row>
              <Table.Cell className="font-medium text-blue-800">
                Generic Name
              </Table.Cell>
              <Table.Cell className="text-blue-900">
                {attributes.generic_name}
              </Table.Cell>
            </Table.Row>
          )}
          
          {attributes.therapeutic_class && (
            <Table.Row>
              <Table.Cell className="font-medium text-blue-800">
                Therapeutic Class
              </Table.Cell>
              <Table.Cell className="text-blue-900">
                {attributes.therapeutic_class}
              </Table.Cell>
            </Table.Row>
          )}
          
          {attributes.primary_indication && (
            <Table.Row>
              <Table.Cell className="font-medium text-blue-800">
                Primary Indication
              </Table.Cell>
              <Table.Cell className="text-blue-900">
                {attributes.primary_indication}
              </Table.Cell>
            </Table.Row>
          )}
          
          {attributes.manufacturer && (
            <Table.Row>
              <Table.Cell className="font-medium text-blue-800">
                Manufacturer
              </Table.Cell>
              <Table.Cell className="text-blue-900">
                {attributes.manufacturer}
              </Table.Cell>
            </Table.Row>
          )}
        </Table.Body>
      </Table>
    </div>
  )
}

const SafetyInfoSection = ({ attributes }: { attributes: PharmaceuticalAttributesDTO }) => {
  if (!attributes.contraindications) {
    return null
  }

  return (
    <div className="bg-red-50 border border-red-200 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-4">
        <ExclamationCircle className="text-red-600" />
        <Text className="text-lg font-semibold text-red-900">
          Important Safety Information
        </Text>
      </div>
      
      <div className="bg-white border border-red-200 rounded p-4">
        <Text className="font-medium text-red-800 mb-2">
          Contraindications:
        </Text>
        <Text className="text-red-700">
          {attributes.contraindications}
        </Text>
      </div>
      
      <div className="mt-4 p-3 bg-yellow-50 border border-yellow-200 rounded">
        <div className="flex items-start gap-2">
          <InformationCircleSolid className="text-yellow-600 mt-0.5 flex-shrink-0" />
          <Text className="text-yellow-800 text-sm">
            <strong>Professional Use Only:</strong> This information is for healthcare professionals. 
            Always consult with a qualified healthcare provider before use.
          </Text>
        </div>
      </div>
    </div>
  )
}

const StoragePackagingSection = ({ attributes }: { attributes: PharmaceuticalAttributesDTO }) => {
  if (!attributes.storage_conditions && !attributes.packaging_size) {
    return null
  }

  return (
    <div className="bg-green-50 border border-green-200 rounded-lg p-6">
      <div className="flex items-center gap-2 mb-4">
        <CheckCircleSolid className="text-green-600" />
        <Text className="text-lg font-semibold text-green-900">
          Storage & Packaging
        </Text>
      </div>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {attributes.storage_conditions && (
          <div className="bg-white border border-green-200 rounded p-4">
            <Text className="font-medium text-green-800 mb-2">
              Storage Conditions
            </Text>
            <Text className="text-green-700">
              {attributes.storage_conditions}
            </Text>
          </div>
        )}
        
        {attributes.packaging_size && (
          <div className="bg-white border border-green-200 rounded p-4">
            <Text className="font-medium text-green-800 mb-2">
              Packaging Information
            </Text>
            <Text className="text-green-700">
              {attributes.packaging_size}
            </Text>
          </div>
        )}
      </div>
    </div>
  )
}

export default PharmaceuticalInfo