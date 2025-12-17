############################################################
# Diamond (filled rhombus) module using ../vector per row
# start_position is the TOP tip of the diamond.
############################################################

module "transformed_start_position" {
  source = "../position"

  start_position   = var.start_position
  translate_vector = var.transform
}

locals {
  origin = module.transformed_start_position.result

  ############################################################
  # 1) Pick orthogonal in-plane axes (u = width axis, v = height axis)
  ############################################################

  axes_by_plane_and_direction = {
    # Ground plane (X right, Z forward)
    xz = {
      east  = { u = { x = 1, y = 0, z = 0 }, v = { x = 0, y = 0, z = 1 } }
      south = { u = { x = 0, y = 0, z = 1 }, v = { x = -1, y = 0, z = 0 } }
      west  = { u = { x = -1, y = 0, z = 0 }, v = { x = 0, y = 0, z = -1 } }
      north = { u = { x = 0, y = 0, z = -1 }, v = { x = 1, y = 0, z = 0 } }
    }

    # Vertical plane (X right, Y up)
    xy = {
      east  = { u = { x = 1, y = 0, z = 0 }, v = { x = 0, y = 1, z = 0 } }
      north = { u = { x = 0, y = 1, z = 0 }, v = { x = -1, y = 0, z = 0 } }
      west  = { u = { x = -1, y = 0, z = 0 }, v = { x = 0, y = -1, z = 0 } }
      south = { u = { x = 0, y = -1, z = 0 }, v = { x = 1, y = 0, z = 0 } }
    }

    # Vertical plane (Y up, Z forward)
    yz = {
      south = { u = { x = 0, y = 1, z = 0 }, v = { x = 0, y = 0, z = 1 } }
      west  = { u = { x = 0, y = 0, z = 1 }, v = { x = 0, y = -1, z = 0 } }
      north = { u = { x = 0, y = -1, z = 0 }, v = { x = 0, y = 0, z = -1 } }
      east  = { u = { x = 0, y = 0, z = -1 }, v = { x = 0, y = 1, z = 0 } }
    }
  }

  u = local.axes_by_plane_and_direction[var.plane][var.direction].u
  v = local.axes_by_plane_and_direction[var.plane][var.direction].v

  ############################################################
  # 2) Diamond row widths (filled)
  #
  # r in [0..height-1]
  # t = min(r, height-1-r) distance from nearest tip
  # denom = floor((height-1)/2) (>=1 when height>1)
  # width(r) = 1 + floor(t * (width-1) / denom)
  ############################################################

  mid   = floor((var.height - 1) / 2)
  denom = max(local.mid, 1)

  row_widths = [
    for r in range(0, var.height) : (
      var.height == 1
      ? var.width
      : (1 + floor((min(r, (var.height - 1 - r)) * (var.width - 1)) / local.denom))
    )
  ]

  ############################################################
  # 3) Emit one vector per row along +u
  #    Center each row by shifting start left along -u
  ############################################################

  u_to_dir = {
    "1,0,0"  = "east"
    "-1,0,0" = "west"
    "0,1,0"  = "up"
    "0,-1,0" = "down"
    "0,0,1"  = "south"
    "0,0,-1" = "north"
  }

  u_key   = "${local.u.x},${local.u.y},${local.u.z}"
  row_dir = local.u_to_dir[local.u_key]

  rowspecs = [
    for r in range(0, var.height) : {
      r      = r
      length = local.row_widths[r]

      start = {
        x = local.origin.x + local.v.x * r + local.u.x * (-floor((local.row_widths[r] - 1) / 2))
        y = local.origin.y + local.v.y * r + local.u.y * (-floor((local.row_widths[r] - 1) / 2))
        z = local.origin.z + local.v.z * r + local.u.z * (-floor((local.row_widths[r] - 1) / 2))
      }
    }
  ]

  rowspecs_by_key = { for rs in local.rowspecs : tostring(rs.r) => rs }

  ############################################################
  # 4) Useful points + debug outputs
  ############################################################

  top = local.origin

  bottom = {
    x = local.origin.x + local.v.x * (var.height - 1)
    y = local.origin.y + local.v.y * (var.height - 1)
    z = local.origin.z + local.v.z * (var.height - 1)
  }

  max_row_width = max(local.row_widths...)
  widest_r      = index(local.row_widths, local.max_row_width)

  widest_row_start = local.rowspecs[local.widest_r].start

  left = local.widest_row_start

  right = {
    x = local.widest_row_start.x + local.u.x * (local.max_row_width - 1)
    y = local.widest_row_start.y + local.u.y * (local.max_row_width - 1)
    z = local.widest_row_start.z + local.u.z * (local.max_row_width - 1)
  }

  block_count = sum(local.row_widths)

  blocks = flatten([
    for rs in local.rowspecs : [
      for c in range(0, rs.length) : {
        x = rs.start.x + local.u.x * c
        y = rs.start.y + local.u.y * c
        z = rs.start.z + local.u.z * c
      }
    ]
  ])
}

module "rows" {
  source = "../vector"

  for_each = local.rowspecs_by_key

  material       = var.material
  length         = each.value.length
  direction      = local.row_dir
  start_position = each.value.start

  transform = {
    x = 0
    y = 0
    z = 0
  }
}

############################################################
# Outputs
############################################################

output "origin" {
  value = local.origin
}

output "block_count" {
  value = local.block_count
}

output "blocks" {
  value = local.blocks
}

output "rows" {
  description = "One vector per diamond row: row index, start coord, and run length."
  value       = local.rowspecs
}

output "points" {
  value = {
    top    = local.top
    bottom = local.bottom
    left   = local.left
    right  = local.right
    widest_row = {
      r     = local.widest_r
      width = local.max_row_width
      start = local.widest_row_start
    }
  }
}
