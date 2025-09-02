import { clx, Button as MedusaButton } from "@medusajs/ui"
type ButtonProps = React.ComponentProps<typeof MedusaButton>

const Button = ({
  children,
  className: classNameProp,
  ...props
}: ButtonProps): React.ReactNode => {
  const variant = props.variant ?? "primary"

  const className = clx(classNameProp, {
    "!shadow-borders-base !border-none border border-pharmint-border bg-background-secondary text-white hover:bg-accent transition-colors":
      variant === "secondary" || props.disabled,
    "!shadow-none bg-accent text-white hover:bg-accent-hover transition-colors":
      variant === "primary" && !props.disabled,
    "!shadow-none bg-transparent text-white border border-pharmint-border hover:bg-background-secondary transition-colors": variant === "transparent",
  })
  return (
    <MedusaButton
      className={`!rounded-full text-sm font-normal ${className}`}
      variant={variant}
      {...props}
    >
      {children}
    </MedusaButton>
  )
}

export default Button
