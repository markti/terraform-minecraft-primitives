module "transformed_start_position" {
  source = "../position"

  start_position   = var.start_position
  translate_vector = var.transform
}


locals {
  origin = module.transformed_start_position.result

  # Pick two in-plane axes U and V depending on plane
  plane_axes = {
    xz = { u = { x = 1, y = 0, z = 0 }, v = { x = 0, y = 0, z = 1 } } # width along +X, height along +/-Z
    xy = { u = { x = 1, y = 0, z = 0 }, v = { x = 0, y = 1, z = 0 } } # width +X, height +Y
    yz = { u = { x = 0, y = 1, z = 0 }, v = { x = 0, y = 0, z = 1 } } # width +Y, height +/-Z
  }

  u_axis = local.plane_axes[var.plane].u
  v_base = local.plane_axes[var.plane].v

  # Direction controls the sign/rotation of V relative to U
  # (keeps U as "width axis" but chooses where the triangle points)
  dir_map = {
    east  = { u = 1, v = 1 }
    west  = { u = -1, v = -1 }
    south = { u = 1, v = 1 }
    north = { u = 1, v = -1 }
  }

  # For xz:
  # - direction east/west flips X
  # - direction north/south flips Z
  # For xy / yz:
  # direction affects the V sign (and U sign if you want mirroring)
  u_sign = (var.direction == "west" ? -1 : 1)
  v_sign = (var.direction == "north" ? -1 : 1)

  u = { x = local.u_axis.x * local.u_sign, y = local.u_axis.y * local.u_sign, z = local.u_axis.z * local.u_sign }
  v = { x = local.v_base.x * local.v_sign, y = local.v_base.y * local.v_sign, z = local.v_base.z * local.v_sign }

  # Filled right triangle rule:
  # For each row r in [0..height-1], fill columns c in [0..max_c(r)]
  # where max_c(r) scales linearly so last row reaches full width.
  #
  # max_c(r) = floor((r * (width - 1)) / (height - 1)) when height > 1
  # If height == 1 => only row 0, fill full width.
  rows = range(0, var.height)

  row_widths = [
    for r in local.rows : (
      var.height == 1
      ? var.width
      : (floor((r * (var.width - 1)) / (var.height - 1)) + 1)
    )
  ]

  cells = flatten([
    for r in range(0, var.height) : [
      for c in range(0, local.row_widths[r]) : {
        r = r
        c = c
      }
    ]
  ])

  blocks = [
    for p in local.cells : {
      x = local.origin.x + local.u.x * p.c + local.v.x * p.r
      y = local.origin.y + local.u.y * p.c + local.v.y * p.r
      z = local.origin.z + local.u.z * p.c + local.v.z * p.r
    }
  ]

  blocks_by_key = { for b in local.blocks : "${b.x},${b.y},${b.z}" => b }
}

resource "minecraft_block" "triangle" {
  for_each = local.blocks_by_key

  material = var.material
  position = {
    x = each.value.x
    y = each.value.y
    z = each.value.z
  }
}

output "origin" {
  value = local.origin
}

output "block_count" {
  value = length(local.blocks)
}

output "blocks" {
  value = local.blocks
}
