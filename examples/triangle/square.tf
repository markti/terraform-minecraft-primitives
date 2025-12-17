

// xy north / east
// yz south east

locals {
  square_start = {
    x = 523
    y = 75
    z = 265
  }
}

module "xy_north2" {
  source = "../../modules/triangle"

  material  = local.direction_materials["north"]
  direction = "north"
  plane     = "xy"
  height    = 4
  width     = 4

  start_position = local.square_start
  transform = {
    x = -1
    y = 0
    z = 0
  }
}

module "xy_east2" {
  source = "../../modules/triangle"

  material  = local.direction_materials["east"]
  direction = "east"
  plane     = "xy"
  height    = 4
  width     = 4

  start_position = local.square_start
  transform = {
    x = 1
    y = 0
    z = 0
  }
}


module "yz_south2" {
  source = "../../modules/triangle"

  material  = local.direction_materials["south"]
  direction = "south"
  plane     = "yz"
  height    = 4
  width     = 4

  start_position = local.square_start
  transform = {
    x = 0
    y = 0
    z = 1
  }
}

module "yz_east2" {
  source = "../../modules/triangle"

  material  = local.direction_materials["east"]
  direction = "east"
  plane     = "yz"
  height    = 4
  width     = 4

  start_position = local.square_start
  transform = {
    x = 0
    y = 0
    z = -1
  }
}
