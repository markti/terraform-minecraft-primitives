locals {
  # Build a grid of unit start positions.
  # i moves along +X, j moves along +Z
  units = {
    for ij in setproduct(range(var.length), range(var.width)) :
    "${ij[0]}_${ij[1]}" => {
      x = var.start_position.x + ij[0]
      y = var.start_position.y
      z = var.start_position.z + ij[1]
    }
  }

  tri_h = var.height
  tri_w = var.height
}

# 1) XY north
module "xy_north" {
  for_each = local.units
  source   = "../triangle"

  material  = var.material
  direction = "north"
  plane     = "xy"
  height    = local.tri_h
  width     = local.tri_w

  start_position = each.value
  transform = {
    x = -1
    y = 0
    z = 0
  }
}

# 2) XY east
module "xy_east" {
  for_each = local.units
  source   = "../triangle"

  material  = var.material
  direction = "east"
  plane     = "xy"
  height    = local.tri_h
  width     = local.tri_w

  start_position = each.value
  transform = {
    x = 1
    y = 0
    z = 0
  }
}

# 3) YZ south
module "yz_south" {
  for_each = local.units
  source   = "../triangle"

  material  = var.material
  direction = "south"
  plane     = "yz"
  height    = local.tri_h
  width     = local.tri_w

  start_position = each.value
  transform = {
    x = 0
    y = 0
    z = 1
  }
}

# 4) YZ east
module "yz_east" {
  for_each = local.units
  source   = "../triangle"

  material  = var.material
  direction = "east"
  plane     = "yz"
  height    = local.tri_h
  width     = local.tri_w

  start_position = each.value
  transform = {
    x = 0
    y = 0
    z = -1
  }
}
