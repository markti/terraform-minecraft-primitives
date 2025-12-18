variable "material" {
  type        = string
  description = "Minecraft block material to use for the dome."
}

variable "start_position" {
  description = "Center of the dome base circle (before optional transform)."
  type = object({
    x = number
    y = number
    z = number
  })
}

variable "transform" {
  description = "Optional translation applied to start_position."
  type = object({
    x = number
    y = number
    z = number
  })
  default = {
    x = 0
    y = 0
    z = 0
  }
}

variable "diameter" {
  type        = number
  description = "Dome base diameter in blocks (integer >= 1)."
  validation {
    condition     = var.diameter >= 1 && floor(var.diameter) == var.diameter
    error_message = "Diameter must be an integer >= 1."
  }
}
