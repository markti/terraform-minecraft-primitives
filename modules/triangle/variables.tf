variable "material" {
  type        = string
  description = "Block ID for the triangle."
}

variable "start_position" {
  description = "Anchor corner of the triangle (right angle corner A)."
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
  description = "Base width in blocks (>= 1, integer)."
  validation {
    condition     = var.width >= 1 && floor(var.width) == var.width
    error_message = "width must be an integer >= 1."
  }
}

variable "height" {
  type        = number
  description = "Triangle height in blocks (>= 1, integer)."
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
