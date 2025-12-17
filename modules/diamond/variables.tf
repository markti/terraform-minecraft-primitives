
variable "material" {
  type        = string
  description = "Block ID for the diamond."
}

variable "start_position" {
  description = "Anchor point of the diamond (TOP tip)."
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
  default = { x = 0, y = 0, z = 0 }
}

variable "width" {
  type        = number
  description = "Maximum row width in blocks (>= 1, integer)."
  validation {
    condition     = var.width >= 1 && floor(var.width) == var.width
    error_message = "width must be an integer >= 1."
  }
}

variable "height" {
  type        = number
  description = "Total diamond height in rows (>= 1, integer)."
  validation {
    condition     = var.height >= 1 && floor(var.height) == var.height
    error_message = "height must be an integer >= 1."
  }
}

variable "direction" {
  type        = string
  description = "Orientation in the plane."
  validation {
    condition     = contains(["north", "south", "east", "west"], var.direction)
    error_message = "direction must be one of: north, south, east, west."
  }
}

variable "plane" {
  type        = string
  description = "Which plane to draw on."
  default     = "xz"
  validation {
    condition     = contains(["xz", "xy", "yz"], var.plane)
    error_message = "plane must be one of: xz, xy, yz."
  }
}
