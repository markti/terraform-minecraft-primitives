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

variable "width" {
  type        = number
  description = "Blocks along the direction (>= 1, integer)."
  validation {
    condition     = var.width >= 1 && floor(var.width) == var.width
    error_message = "Length must be an integer >= 1."
  }
}

variable "height" {
  type        = number
  description = "Number of blocks to fill along the direction (>= 1)."
  validation {
    condition     = var.height >= 1 && floor(var.height) == var.height
    error_message = "Length must be an integer >= 1."
  }
}

variable "direction" {
  type        = string
  description = "Horizontal run direction.  Must be one of the valid values."
  validation {
    condition     = contains(local.valid_directions, var.direction)
    error_message = "Must be a valid direction: ${join(", ", formatlist("'%s'", local.valid_directions))}"
  }
}

variable "vertical" {
  type        = string
  description = "Vertical slope. Must be one of:  Must be one of the valid values."
  validation {
    condition     = contains(local.valid_vertical, var.vertical)
    error_message = "Must be a valid vertical: ${join(", ", formatlist("'%s'", local.valid_vertical))}"
  }
}

