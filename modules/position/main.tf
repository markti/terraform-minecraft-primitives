locals {
  # Pure translation: p' = p + t
  translated_position = {
    x = var.start_position.x + var.translate_vector.x
    y = var.start_position.y + var.translate_vector.y
    z = var.start_position.z + var.translate_vector.z
  }
}
