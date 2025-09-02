import { listRegions } from "@/lib/data/regions"
import FeaturedProducts from "@/modules/home/components/featured-products"
import Hero from "@/modules/home/components/hero"
import NewArrivals from "@/modules/home/components/new-arrivals"
import BestSellers from "@/modules/home/components/best-sellers"
import EssentialMedicines from "@/modules/home/components/essential-medicines"
import SkeletonFeaturedProducts from "@/modules/skeletons/templates/skeleton-featured-products"
import { Metadata } from "next"
import { Suspense } from "react"

export const dynamicParams = true

export const metadata: Metadata = {
  title: "Pharmint B2B Platform",
  description: "A comprehensive B2B pharmaceutical platform for streamlined procurement and company management.",
}

export async function generateStaticParams() {
  const countryCodes = await listRegions().then(
    (regions) =>
      regions
        ?.map((r) => r.countries?.map((c) => c.iso_2))
        .flat()
        .filter(Boolean) as string[]
  )
  return countryCodes.map((countryCode) => ({ countryCode }))
}

export default async function Home(props: {
  params: Promise<{ countryCode: string }>
}) {
  const params = await props.params

  const { countryCode } = params

  return (
    <div className="flex flex-col">
      <Hero />
      <Suspense fallback={<SkeletonFeaturedProducts />}>
        <FeaturedProducts countryCode={countryCode} />
      </Suspense>
      <Suspense fallback={<div className="py-12" />}>
        <NewArrivals countryCode={countryCode} />
      </Suspense>
      <Suspense fallback={<div className="py-12" />}>
        <BestSellers countryCode={countryCode} />
      </Suspense>
      <Suspense fallback={<div className="py-12" />}>
        <EssentialMedicines countryCode={countryCode} />
      </Suspense>
    </div>
  )
}