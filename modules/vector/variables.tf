variable "material" {
  type        = string
  description = "value"
}

variable "start_position" {
  description = "North = -Z, South +Z, East +X, West -X"
  type = object({
    x = number
    y = number
    z = number
  })
}

variable "transform" {
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

variable "length" {
  type        = number
  description = "Number of blocks to fill along the direction (>= 1)."
  validation {
    condition     = var.length >= 1 && floor(var.length) == var.length
    error_message = "Length must be an integer >= 1."
  }
}

variable "direction" {
  type        = string
  description = "The direction of placement. Must be one of the valid values."
  validation {
    condition     = contains(local.directions, var.direction)
    error_message = "Must be a valid direction: ${join(", ", local.directions)}"
  }
}
