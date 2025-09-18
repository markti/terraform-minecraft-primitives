variable "material" {
  type        = string
  description = "Stairs block ID, e.g. 'minecraft:stone_stairs'."
}

variable "start_position" {
  description = "Row start. North = -Z, South = +Z, East = +X, West = -X."
  type = object({
    x = number
    y = number
    z = number
  })
}

variable "direction" {
  type        = string
  description = "Row direction. One of 'north', 'south', 'east', 'west'."
  validation {
    condition     = contains(["north", "south", "east", "west"], var.direction)
    error_message = "Must be one of: 'north', 'south', 'east', 'west'."
  }
}

variable "width" {
  type        = number
  description = "Number of straight stair blocks in the row (>= 1)."
  validation {
    condition     = var.width >= 1 && floor(var.width) == var.width
    error_message = "width must be an integer >= 1."
  }
}

variable "half" {
  type        = string
  description = "Stairs half: 'bottom' or 'top'."
  default     = "bottom"
  validation {
    condition     = contains(["bottom", "top"], var.half)
    error_message = "half must be 'bottom' or 'top'."
  }
}

# If your row grows the opposite way from what you want, flip this.
variable "row_invert" {
  type    = bool
  default = false
}

# Corner toggles: start side and end side, left/right (relative to facing)
variable "enable_start_left_corner" {
  type    = bool
  default = false
}
variable "enable_end_right_corner" {
  type    = bool
  default = false
}
# If your provider mirrors outer_left/right, flip this.
variable "corner_shape_swap" {
  type    = bool
  default = false
}
