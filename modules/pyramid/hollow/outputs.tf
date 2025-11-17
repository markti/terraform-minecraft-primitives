output "base_position" {
  value = {
    center = local.base_center
    corners = {
      north_west = local.base_north_west
      north_east = local.base_north_east
      south_west = local.base_south_west
      south_east = local.base_south_east
    }
    side_centers = {
      north = local.base_center_north
      south = local.base_center_south
      west  = local.base_center_west
      east  = local.base_center_east
    }
    all = {
      north_west = local.base_north_west
      north_east = local.base_north_east
      south_west = local.base_south_west
      south_east = local.base_south_east
      north      = local.base_center_north
      south      = local.base_center_south
      west       = local.base_center_west
      east       = local.base_center_east
      center     = local.base_center
    }
  }
}

output "peak_position" {
  value = {
    center     = local.peak_center
    north_west = local.peak_north_west
    north_east = local.peak_north_east
    south_west = local.peak_south_west
    south_east = local.peak_south_east
    all = local.cap_size == 1 ? {
      center = local.peak_center
      } : {
      north_west = local.peak_north_west
      north_east = local.peak_north_east
      south_west = local.peak_south_west
      south_east = local.peak_south_east
    }
  }
}
