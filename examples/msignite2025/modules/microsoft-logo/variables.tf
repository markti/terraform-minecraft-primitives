variable "start_position" {
  description = "Bottom-north-west corner of the wooden pedestal."
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
  type = number
}

variable "pedestal_depth" {
  description = "Depth of the pedestal along Z."
  type        = number
  default     = 3
}

variable "pedestal_height" {
  description = "Height/thickness of the pedestal along Y."
  type        = number
  default     = 1
}
