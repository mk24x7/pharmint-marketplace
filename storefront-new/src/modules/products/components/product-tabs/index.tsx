"use client"

import { HttpTypes } from "@medusajs/types"
import { Table, Text } from "@medusajs/ui"
import Markdown from "react-markdown"
import Accordion from "./accordion"
import PharmaceuticalInfo from "../pharmaceutical-info"
import { PharmaceuticalAttributesDTO } from "@/types/pharmaceutical-attributes"

type ProductTabsProps = {
  product: HttpTypes.StoreProduct
}

const ProductTabs = ({ product }: ProductTabsProps) => {
  // Type assertion to access pharmaceutical_attributes if they exist
  const productWithPharma = product as HttpTypes.StoreProduct & {
    pharmaceutical_attributes?: PharmaceuticalAttributesDTO
  }

  const tabs = [
    {
      label: "Description",
      component: <ProductSpecsTab product={product} />,
    },
    {
      label: "Specifications",
      component: <ProductSpecificationsTab product={product} />,
    },
    // Only show pharmaceutical tab if attributes exist
    ...(productWithPharma.pharmaceutical_attributes ? [{
      label: "Pharmaceutical Information",
      component: <PharmaceuticalInfo 
        product={product} 
        pharmaceuticalAttributes={productWithPharma.pharmaceutical_attributes} 
      />,
    }] : []),
  ]

  return (
    <div className="w-full">
      <Accordion type="multiple" className="flex flex-col gap-y-2">
        {tabs.map((tab, i) => (
          <Accordion.Item
            className="bg-background-secondary border border-pharmint-border small:px-24 px-6"
            key={i}
            title={tab.label}
            headingSize="medium"
            value={tab.label}
          >
            {tab.component}
          </Accordion.Item>
        ))}
      </Accordion>
    </div>
  )
}

const ProductSpecsTab = ({ product }: ProductTabsProps) => {
  return (
    <div className="text-small-regular py-8 xl:w-2/3">
      <Markdown
        components={{
          p: ({ children }) => (
            <Text className="text-white mb-2">{children}</Text>
          ),
          h2: ({ children }) => (
            <Text className="text-xl text-white my-4 font-semibold">
              {children}
            </Text>
          ),
          h3: ({ children }) => (
            <Text className="text-lg text-white mb-2">{children}</Text>
          ),
        }}
      >
        {product.description ? product.description : "-"}
      </Markdown>
    </div>
  )
}

const ProductSpecificationsTab = ({ product }: ProductTabsProps) => {
  return (
    <div className="text-small-regular py-8">
      <Table className="rounded-lg shadow-borders-base overflow-hidden border-none">
        <Table.Body>
          {product.weight && (
            <Table.Row>
              <Table.Cell className="border-r">
                <span className="font-semibold">Weight</span>
              </Table.Cell>
              <Table.Cell className="px-4">{product.weight} grams</Table.Cell>
            </Table.Row>
          )}
          {(product.height || product.width || product.length) && (
            <Table.Row>
              <Table.Cell className="border-r">
                <span className="font-semibold">Dimensions (HxWxL)</span>
              </Table.Cell>
              <Table.Cell className="px-4">
                {product.height}mm x {product.width}mm x {product.length}mm
              </Table.Cell>
            </Table.Row>
          )}

          {product.metadata &&
            Object.entries(product.metadata).map(([key, value]) => (
              <Table.Row key={key}>
                <Table.Cell className="border-r">
                  <span className="font-semibold">{key}</span>
                </Table.Cell>
                <Table.Cell className="px-4">
                  <p>{value as string}</p>
                </Table.Cell>
              </Table.Row>
            ))}
        </Table.Body>
      </Table>
    </div>
  )
}

export default ProductTabs
