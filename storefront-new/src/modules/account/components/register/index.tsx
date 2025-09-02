"use client"

import { signup } from "@/lib/data/customer"
import { LOGIN_VIEW } from "@/modules/account/templates/login-template"
import ErrorMessage from "@/modules/checkout/components/error-message"
import { SubmitButton } from "@/modules/checkout/components/submit-button"
import Input from "@/modules/common/components/input"
import { Checkbox, Label } from "@medusajs/ui"
import { ChangeEvent, useActionState, useState } from "react"

type Props = {
  setCurrentView: (view: LOGIN_VIEW) => void
}

interface FormData {
  email: string
  first_name: string
  password: string
}

const initialFormData: FormData = {
  email: "",
  first_name: "",
  password: "",
}


const Register = ({ setCurrentView }: Props) => {
  const [message, formAction] = useActionState(signup, null)
  const [termsAccepted, setTermsAccepted] = useState(false)
  const [formData, setFormData] = useState<FormData>(initialFormData)

  const handleChange = (
    e: ChangeEvent<HTMLInputElement | HTMLSelectElement>
  ) => {
    const { name, value } = e.target
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }))
  }


  const isValid =
    termsAccepted &&
    !!formData.email &&
    !!formData.first_name &&
    !!formData.password


  return (
    <div
      className="max-w-sm flex flex-col items-start gap-2 my-8"
      data-testid="register-page"
    >
      <div className="mb-6">
        <h1 
          className="text-4xl sm:text-5xl font-bold text-white text-left leading-tight mb-2"
          style={{
            background: 'linear-gradient(180deg, #FFFFFF 0%, rgba(255, 255, 255, 0.9) 100%)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            backgroundClip: 'text'
          }}
        >
          Join Pharmint
        </h1>
        <p className="text-lg text-accent font-medium">
          Create your company account - takes less than a minute
        </p>
      </div>
      <form className="w-full flex flex-col" action={formAction}>
        <div className="flex flex-col w-full gap-y-4">
          <Input
            label="Email"
            name="email"
            required
            type="email"
            autoComplete="email"
            data-testid="email-input"
            className=""
            value={formData.email}
            onChange={handleChange}
          />
          <Input
            label="First name"
            name="first_name"
            required
            autoComplete="given-name"
            data-testid="first-name-input"
            className=""
            value={formData.first_name}
            onChange={handleChange}
          />
          <Input
            label="Password"
            name="password"
            required
            type="password"
            autoComplete="new-password"
            data-testid="password-input"
            className=""
            value={formData.password}
            onChange={handleChange}
          />
          {/* Hidden fields for default values */}
          <input type="hidden" name="last_name" value="" />
          <input type="hidden" name="company_name" value="Default Company" />
          <input type="hidden" name="company_country" value="Philippines" />
          <input type="hidden" name="currency_code" value="php" />
        </div>
        <div className="bg-background-secondary/50 border border-pharmint-border rounded-lg p-4 my-4">
          <p className="text-sm text-pharmint-muted">
            📝 <strong className="text-white">Note:</strong> You can complete your full profile (last name, company details, address, etc.) later in your account settings. By default, your location is set to Philippines with PHP currency.
          </p>
        </div>
        <ErrorMessage error={message} data-testid="register-error" />
        <div className="flex items-center gap-2">
          <Checkbox
            name="terms"
            id="terms-checkbox"
            data-testid="terms-checkbox"
            checked={termsAccepted}
            onCheckedChange={(checked) => setTermsAccepted(!!checked)}
          ></Checkbox>
          <Label
            id="terms-label"
            className="flex items-center text-white !text-xs hover:cursor-pointer !transform-none"
            htmlFor="terms-checkbox"
            data-testid="terms-label"
          >
            I agree to the terms and conditions and privacy policy.
          </Label>
        </div>
        <SubmitButton
          className="w-full h-12 mt-8 bg-accent hover:bg-accent-hover text-white font-semibold transition-all duration-200 transform hover:scale-105 hover:shadow-lg hover:shadow-accent/25"
          data-testid="register-button"
          disabled={!isValid}
        >
          Create Account
        </SubmitButton>
      </form>
      <span className="text-center text-pharmint-muted text-small-regular mt-6">
        Already a member?{" "}
        <button
          onClick={() => setCurrentView(LOGIN_VIEW.LOG_IN)}
          className="text-accent hover:text-accent-hover underline transition-colors duration-200"
        >
          Sign in
        </button>
        .
      </span>
    </div>
  )
}

export default Register
