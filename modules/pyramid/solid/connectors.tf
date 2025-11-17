locals {
  ########################################
  # Base geometry (on y = base_start.y)
  ########################################

  # Corners (start is north_west: min X, min Z; we grow +X (east) and +Z (south))
  base_north_west = local.base_start

  base_north_east = {
    x = local.base_start.x + local.base_size - 1
    y = local.base_start.y
    z = local.base_start.z
  }

  base_south_west = {
    x = local.base_start.x
    y = local.base_start.y
    z = local.base_start.z + local.base_size - 1
  }

  base_south_east = {
    x = local.base_start.x + local.base_size - 1
    y = local.base_start.y
    z = local.base_start.z + local.base_size - 1
  }

  # Half span (for centers). Can be fractional for even sizes.
  base_half = floor((local.base_size - 1) / 2)

  # Side centers on base
  base_center_north = {
    x = local.base_start.x + local.base_half
    y = local.base_start.y
    z = local.base_start.z
  }

  base_center_south = {
    x = local.base_start.x + local.base_half
    y = local.base_start.y
    z = local.base_start.z + local.base_size - 1
  }

  base_center_west = {
    x = local.base_start.x
    y = local.base_start.y
    z = local.base_start.z + local.base_half
  }

  base_center_east = {
    x = local.base_start.x + local.base_size - 1
    y = local.base_start.y
    z = local.base_start.z + local.base_half
  }

  # Center of the base square
  base_center = {
    x = local.base_start.x + local.base_half
    y = local.base_start.y
    z = local.base_start.z + local.base_half
  }

  ########################################
  # Peak geometry (top solid layer)
  ########################################

  # cap_size matches your hollow version: 1×1 for odd, 2×2 for even
  cap_size = var.length % 2 == 1 ? 1 : 2

  # last index i where side_len(i) == cap_size
  # side_len(i) = length - 2*i
  peak_layer = {
    side_len = var.length - 2 * local.max_index
    y        = local.base_start.y + local.max_index
    x0       = local.base_start.x + local.max_index
    z0       = local.base_start.z + local.max_index
  }

  # Top "cap" corners at the peak
  peak_north_west = {
    x = local.peak_layer.x0
    y = local.peak_layer.y
    z = local.peak_layer.z0
  }

  peak_north_east = {
    x = local.peak_layer.x0 + local.peak_layer.side_len - 1
    y = local.peak_layer.y
    z = local.peak_layer.z0
  }

  peak_south_west = {
    x = local.peak_layer.x0
    y = local.peak_layer.y
    z = local.peak_layer.z0 + local.peak_layer.side_len - 1
  }

  peak_south_east = {
    x = local.peak_layer.x0 + local.peak_layer.side_len - 1
    y = local.peak_layer.y
    z = local.peak_layer.z0 + local.peak_layer.side_len - 1
  }

  # Per your rule:
  # - If side_len == 1 (odd base), all four are the same point
  # - If side_len == 2 (even base), center = north_west of the 2×2
  peak_center = local.peak_north_west
}

locals {
  # Per-layer square ranges for each Y level of the solid pyramid
  layer_ranges = [
    for lvl in local.solid_levels : {
      index    = lvl.idx
      y        = lvl.y
      side_len = lvl.side_len

      min_x = lvl.x0
      max_x = lvl.x0 + lvl.side_len - 1

      min_z = lvl.z0
      max_z = lvl.z0 + lvl.side_len - 1
    }
  ]
}
locals {
  exterior_blocks = flatten([
    for lvl in local.layer_ranges : flatten([
      # North edge
      [
        for x in range(lvl.min_x, lvl.max_x + 1) : {
          x = x
          y = lvl.y
          z = lvl.min_z
        }
      ],

      # South edge
      [
        for x in range(lvl.min_x, lvl.max_x + 1) : {
          x = x
          y = lvl.y
          z = lvl.max_z
        }
      ],

      # West edge
      [
        for z in range(lvl.min_z, lvl.max_z + 1) : {
          x = lvl.min_x
          y = lvl.y
          z = z
        }
      ],

      # East edge
      [
        for z in range(lvl.min_z, lvl.max_z + 1) : {
          x = lvl.max_x
          y = lvl.y
          z = z
        }
      ]
    ])
  ])
}
