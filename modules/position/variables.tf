variable "start_position" {
  description = "North = -Z, South +Z, East +X, West -X"
  type = object({
    x = number
    y = number
    z = number
  })
}
variable "translate_vector" {
  type = object({
    x = number
    y = number
    z = number
  })
}
