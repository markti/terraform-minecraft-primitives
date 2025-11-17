variable "material" {
  type = string
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
  description = "Blocks along the direction (>= 1, integer)."
  validation {
    condition     = var.length >= 1 && floor(var.length) == var.length
    error_message = "Length must be an integer >= 1."
  }
}
