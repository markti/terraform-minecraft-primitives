variable "start_position" {
  description = "Anchor position (x,y,z) for the first corner unit in the platform."
  type = object({
    x = number
    y = number
    z = number
  })
}

variable "length" {
  description = "How many corner units to place along +X."
  type        = number
}

variable "width" {
  description = "How many corner units to place along +Z."
  type        = number
}

variable "height" {
  description = "Triangle height (also used as triangle width)."
  type        = number
}

variable "material" {
  description = "Materials per direction used by the triangles."
  type        = string
}
