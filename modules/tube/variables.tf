variable "material" {
  type        = string
  description = "Block ID for the ring (e.g., 'minecraft:stone')."
}

variable "start_position" {
  description = "CENTER of the circle's start face. North=-Z, South=+Z, East=+X, West=-X."
  type = object({
    x = number
    y = number
    z = number
  })
}

variable "diameter" {
  type        = number
  description = "Circle diameter in blocks (>= 3, integer)."
  validation {
    condition     = var.diameter >= 3 && floor(var.diameter) == var.diameter
    error_message = "diameter must be an integer >= 3."
  }
}

variable "depth" {
  type        = number
  description = "Extrusion length along direction (>= 1, integer)."
  validation {
    condition     = var.depth >= 1 && floor(var.depth) == var.depth
    error_message = "depth must be an integer >= 1."
  }
}

variable "direction" {
  type        = string
  description = "Extrusion direction."
  validation {
    condition     = contains(local.directions, var.direction)
    error_message = "direction must be one of: ${join(", ", local.directions)}"
  }
}
