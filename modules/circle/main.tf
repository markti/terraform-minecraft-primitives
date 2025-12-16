module "transformed_start_position" {
  source = "../position"

  start_position   = var.start_position
  translate_vector = var.transform
}

locals {
  center = module.transformed_start_position.result

  dir_to_delta = {
    north = { x = 0, y = 0, z = -1 }
    south = { x = 0, y = 0, z = 1 }
    west  = { x = -1, y = 0, z = 0 }
    east  = { x = 1, y = 0, z = 0 }
    up    = { x = 0, y = 1, z = 0 }
    down  = { x = 0, y = 0, z = -1 }
  }

  # Choose the disc plane axes
  plane_axes = {
    north = { u = { x = 1, y = 0, z = 0 }, v = { x = 0, y = 1, z = 0 } }
    south = { u = { x = -1, y = 0, z = 0 }, v = { x = 0, y = 1, z = 0 } }
    east  = { u = { x = 0, y = 0, z = 1 }, v = { x = 0, y = 1, z = 0 } }
    west  = { u = { x = 0, y = 0, z = -1 }, v = { x = 0, y = 1, z = 0 } }
    up    = { u = { x = 1, y = 0, z = 0 }, v = { x = 0, y = 0, z = 1 } }
    down  = { u = { x = 1, y = 0, z = 0 }, v = { x = 0, y = 0, z = -1 } }
  }

  u_axis = local.plane_axes[var.direction].u
  v_axis = local.plane_axes[var.direction].v

  # 0-based grid across diameter
  indices = range(0, var.diameter)

  radius = var.diameter / 2

  candidates = flatten([
    for ui in local.indices : [
      for vi in local.indices : {
        ui = ui
        vi = vi
      }
    ]
  ])

  # Proper Minecraft-style disc test (cell-center based)
  included = [
    for p in local.candidates : p
    if(
      pow((p.ui + 0.5) - local.radius, 2) +
      pow((p.vi + 0.5) - local.radius, 2)
    ) <= pow(local.radius, 2)
  ]

  center_i = floor((var.diameter - 1) / 2)

  blocks = [
    for p in local.included : {
      x = local.center.x + local.u_axis.x * (p.ui - local.center_i) + local.v_axis.x * (p.vi - local.center_i)
      y = local.center.y + local.u_axis.y * (p.ui - local.center_i) + local.v_axis.y * (p.vi - local.center_i)
      z = local.center.z + local.u_axis.z * (p.ui - local.center_i) + local.v_axis.z * (p.vi - local.center_i)
    }
  ]

  blocks_by_key = { for b in local.blocks : "${b.x},${b.y},${b.z}" => b }
}

resource "minecraft_block" "disc" {
  for_each = local.blocks_by_key

  material = var.material
  position = {
    x = each.value.x
    y = each.value.y
    z = each.value.z
  }
}
