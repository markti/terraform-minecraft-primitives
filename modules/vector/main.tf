module "transformed_start_position" {
  source = "../position"

  start_position   = var.start_position
  translate_vector = var.transform
}

locals {
  start_position = module.transformed_start_position.result
  # Unit step vectors per direction (right-handed: +x east, +y up, +z south)
  dir_to_delta = {
    north = { x = 0, y = 0, z = -1 }
    south = { x = 0, y = 0, z = 1 }
    west  = { x = -1, y = 0, z = 0 }
    east  = { x = 1, y = 0, z = 0 }
    up    = { x = 0, y = 1, z = 0 }
    down  = { x = 0, y = -1, z = 0 }
  }

  step = local.dir_to_delta[var.direction]

  # Inclusive end: start + step * (length - 1)
  end_position = {
    x = local.start_position.x + local.step.x * (var.length - 1)
    y = local.start_position.y + local.step.y * (var.length - 1)
    z = local.start_position.z + local.step.z * (var.length - 1)
  }
}

resource "minecraft_fill" "main" {
  material = var.material

  start = {
    x = local.start_position.x
    y = local.start_position.y
    z = local.start_position.z
  }

  end = {
    x = local.end_position.x
    y = local.end_position.y
    z = local.end_position.z
  }
}
