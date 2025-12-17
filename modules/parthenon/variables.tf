variable "start_position" {
  type = object({
    x = number
    y = number
    z = number
  })
}

variable "ziggurat" {
  type = object({
    material = string
    length   = number
    width    = number
    height   = number
  })
}

variable "temple" {
  type = object({
    # If null, we auto-fit it inside the top surface.
    length = optional(number)
    width  = optional(number)

    stylobate_height   = number
    column_height      = number
    column_spacing     = number
    column_inset       = number
    entablature_height = number
    roof_height        = number

    materials = object({
      stylobate   = string
      columns     = string
      entablature = string
      roof        = string
    })
  })
}
