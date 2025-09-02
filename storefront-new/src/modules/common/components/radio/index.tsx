const Radio = ({
  checked,
  "data-testid": dataTestId,
  disabled,
}: {
  checked: boolean
  "data-testid"?: string
  disabled?: boolean
}) => {
  return (
    <>
      <button
        type="button"
        role="radio"
        aria-checked="true"
        data-state={checked ? "checked" : "unchecked"}
        className="group relative flex h-5 w-5 items-center justify-center outline-none"
        data-testid={dataTestId || "radio-button"}
        disabled={disabled}
      >
        <div className="border border-pharmint-border hover:border-accent bg-background-secondary group-data-[state=checked]:bg-accent group-data-[state=checked]:border-accent group-focus:border-accent group-disabled:bg-background-secondary group-disabled:border-pharmint-border flex h-[14px] w-[14px] items-center justify-center rounded-full transition-all">
          {checked && (
            <span
              data-state={checked ? "checked" : "unchecked"}
              className="group flex items-center justify-center"
            >
              <div className="bg-white rounded-full h-1.5 w-1.5"></div>
            </span>
          )}
        </div>
      </button>
    </>
  )
}

export default Radio
