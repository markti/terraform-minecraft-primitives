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

variable "length" {
  type        = number
  description = "Blocks along the direction (>= 1, integer)."
  validation {
    condition     = var.length >= 1 && floor(var.length) == var.length
    error_message = "Length must be an integer >= 1."
  }
}

variable "top_cap" {
  type        = bool
  description = "Add a solid top cap (1×1 for odd, 2×2 for even)."
  default     = false
}
