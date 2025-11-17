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
  base_half = (local.base_size - 1) / 2.0

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
  # Peak geometry (top cap layer)
  ########################################

  # Top cap corner positions
  peak_north_west = {
    x = local.top_cap_layer.x0
    y = local.top_cap_layer.y
    z = local.top_cap_layer.z0
  }

  peak_north_east = {
    x = local.top_cap_layer.x0 + local.top_cap_layer.side_len - 1
    y = local.top_cap_layer.y
    z = local.top_cap_layer.z0
  }

  peak_south_west = {
    x = local.top_cap_layer.x0
    y = local.top_cap_layer.y
    z = local.top_cap_layer.z0 + local.top_cap_layer.side_len - 1
  }

  peak_south_east = {
    x = local.top_cap_layer.x0 + local.top_cap_layer.side_len - 1
    y = local.top_cap_layer.y
    z = local.top_cap_layer.z0 + local.top_cap_layer.side_len - 1
  }

  # Per your rule:
  # - If side_len == 1 (odd base), all these are the same point anyway.
  # - If side_len == 2 (even base), center = north_west of the 2×2.
  peak_center = local.peak_north_west
}
