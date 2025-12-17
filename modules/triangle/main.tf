module "transformed_start_position" {
  source = "../position"

  start_position   = var.start_position
  translate_vector = var.transform
}

locals {
  origin = module.transformed_start_position.result

  ############################################################
  # 1) Pick orthogonal in-plane axes (u = width leg, v = height leg)
  #
  # We rotate the (u,v) pair by direction so pinwheels/windmills work.
  ############################################################

  axes_by_plane_and_direction = {
    # Ground plane
    xz = {
      east  = { u = { x = 1, y = 0, z = 0 }, v = { x = 0, y = 0, z = 1 } }   # +X, +Z
      south = { u = { x = 0, y = 0, z = 1 }, v = { x = -1, y = 0, z = 0 } }  # +Z, -X
      west  = { u = { x = -1, y = 0, z = 0 }, v = { x = 0, y = 0, z = -1 } } # -X, -Z
      north = { u = { x = 0, y = 0, z = -1 }, v = { x = 1, y = 0, z = 0 } }  # -Z, +X
    }

    # Vertical plane facing you (X right, Y up)
    xy = {
      east  = { u = { x = 1, y = 0, z = 0 }, v = { x = 0, y = 1, z = 0 } }   # +X, +Y
      north = { u = { x = 0, y = 1, z = 0 }, v = { x = -1, y = 0, z = 0 } }  # +Y, -X
      west  = { u = { x = -1, y = 0, z = 0 }, v = { x = 0, y = -1, z = 0 } } # -X, -Y
      south = { u = { x = 0, y = -1, z = 0 }, v = { x = 1, y = 0, z = 0 } }  # -Y, +X
    }

    # Vertical plane (Y up, Z forward)
    yz = {
      south = { u = { x = 0, y = 1, z = 0 }, v = { x = 0, y = 0, z = 1 } }   # +Y, +Z
      west  = { u = { x = 0, y = 0, z = 1 }, v = { x = 0, y = -1, z = 0 } }  # +Z, -Y
      north = { u = { x = 0, y = -1, z = 0 }, v = { x = 0, y = 0, z = -1 } } # -Y, -Z
      east  = { u = { x = 0, y = 0, z = -1 }, v = { x = 0, y = 1, z = 0 } }  # -Z, +Y
    }
  }

  u = local.axes_by_plane_and_direction[var.plane][var.direction].u
  v = local.axes_by_plane_and_direction[var.plane][var.direction].v

  ############################################################
  # 2) Triangle row widths (filled, shrinking away from A)
  #
  # r=0      => full width
  # r=height-1 => 1
  ############################################################

  row_widths = [
    for r in range(0, var.height) : (
      var.height == 1
      ? var.width
      : (var.width - floor((r * (var.width - 1)) / (var.height - 1)))
    )
  ]

  ############################################################
  # 3) Emit one vector per row along +u (or -u)
  ############################################################

  # Convert u vector into a direction string for the vector module
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
        x = local.origin.x + local.v.x * r
        y = local.origin.y + local.v.y * r
        z = local.origin.z + local.v.z * r
      }
    }
  ]

  rowspecs_by_key = { for rs in local.rowspecs : tostring(rs.r) => rs }

  ############################################################
  # 4) Key points (A,B,C) and midpoints
  ############################################################

  A = local.origin

  # Width leg end (always a real corner with the shrinking-row convention)
  B = {
    x = local.origin.x + local.u.x * (var.width - 1)
    y = local.origin.y + local.u.y * (var.width - 1)
    z = local.origin.z + local.u.z * (var.width - 1)
  }

  # Height leg end
  C = {
    x = local.origin.x + local.v.x * (var.height - 1)
    y = local.origin.y + local.v.y * (var.height - 1)
    z = local.origin.z + local.v.z * (var.height - 1)
  }

  AB = {
    x = floor((local.A.x + local.B.x) / 2)
    y = floor((local.A.y + local.B.y) / 2)
    z = floor((local.A.z + local.B.z) / 2)
  }

  AC = {
    x = floor((local.A.x + local.C.x) / 2)
    y = floor((local.A.y + local.C.y) / 2)
    z = floor((local.A.z + local.C.z) / 2)
  }

  BC = {
    x = floor((local.B.x + local.C.x) / 2)
    y = floor((local.B.y + local.C.y) / 2)
    z = floor((local.B.z + local.C.z) / 2)
  }

  ############################################################
  # 5) For debugging/inspection: block count and block list (optional)
  ############################################################

  block_count = sum(local.row_widths)

  # If you still want the full list of block coordinates, we can generate it;
  # keeping it here because you’ve been outputting it.
  blocks = flatten([
    for r in range(0, var.height) : [
      for c in range(0, local.row_widths[r]) : {
        x = local.origin.x + local.u.x * c + local.v.x * r
        y = local.origin.y + local.u.y * c + local.v.y * r
        z = local.origin.z + local.u.z * c + local.v.z * r
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

  # IMPORTANT: this assumes your vector module draws starting *at* start_position.
  # If your vector module requires a one-block nudge like your connectors did,
  # change this to transform = local.u
  transform = {
    x = 0
    y = 0
    z = 0
  }
}

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
  description = "One vector per triangle row: row index, start coord, and run length."
  value       = local.rowspecs
}

output "points" {
  value = {
    A  = local.A
    B  = local.B
    C  = local.C
    AB = local.AB
    AC = local.AC
    BC = local.BC
    all = {
      A  = local.A
      B  = local.B
      C  = local.C
      AB = local.AB
      AC = local.AC
      BC = local.BC
    }
  }
}
