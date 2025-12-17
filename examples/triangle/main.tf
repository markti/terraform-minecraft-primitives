locals {
  point_colors = {
    A = "red_wool"
    B = "white_wool"
    C = "blue_wool"
  }
  direction_materials = {
    north = "copper_block"
    south = "iron_block"
    east  = "gold_block"
    west  = "diamond_block"
  }
}

module "east" {
  source = "../../modules/triangle"

  material  = local.direction_materials["east"]
  direction = "east"
  height    = 7
  width     = 7

  start_position = {
    x = 557
    y = 83
    z = 312
  }
}

locals {
  east_points = {
    A = module.east.points.A
    B = module.east.points.B
    C = module.east.points.C
  }
}

module "east_vectors" {
  source = "../../modules/vector"

  for_each = local.east_points

  material       = local.point_colors[each.key]
  length         = 3
  direction      = "up"
  start_position = each.value

  transform = {
    x = 0
    y = 1
    z = 0
  }
}

module "west" {
  source = "../../modules/triangle"

  material  = local.direction_materials["west"]
  direction = "west"
  height    = 7
  width     = 7

  start_position = module.east.points.A
  transform = {
    x = -1
    y = 0
    z = -1
  }
}

locals {
  west_points = {
    A = module.west.points.A
    B = module.west.points.B
    C = module.west.points.C
  }
}

module "west_vectors" {
  source = "../../modules/vector"

  for_each = local.west_points

  material       = local.point_colors[each.key]
  length         = 3
  direction      = "up"
  start_position = each.value

  transform = {
    x = 0
    y = 1
    z = 0
  }
}

module "north" {
  source = "../../modules/triangle"

  material  = local.direction_materials["north"]
  direction = "north"
  height    = 7
  width     = 7

  start_position = module.west.points.C
  transform = {
    x = 1
    y = 0
    z = -1
  }
}

locals {
  north_points = {
    A = module.north.points.A
    B = module.north.points.B
    C = module.north.points.C
  }
}

module "north_vectors" {
  source = "../../modules/vector"

  for_each = local.north_points

  material       = local.point_colors[each.key]
  length         = 3
  direction      = "up"
  start_position = each.value

  transform = {
    x = 0
    y = 1
    z = 0
  }
}

module "south" {
  source = "../../modules/triangle"

  material  = local.direction_materials["south"]
  direction = "south"
  height    = 7
  width     = 7

  start_position = module.north.points.B
  transform = {
    x = -1
    y = 0
    z = -7
  }
}

locals {
  south_points = {
    A = module.south.points.A
    B = module.south.points.B
    C = module.south.points.C
  }
}

module "south_vectors" {
  source = "../../modules/vector"

  for_each = local.south_points

  material       = local.point_colors[each.key]
  length         = 3
  direction      = "up"
  start_position = each.value

  transform = {
    x = 0
    y = 1
    z = 0
  }
}


module "xy_south" {
  source = "../../modules/triangle"

  material  = local.direction_materials["south"]
  direction = "south"
  plane     = "xy"
  height    = 4
  width     = 4

  start_position = module.south_vectors["B"].end_position
  transform = {
    x = 1
    y = 4
    z = 0
  }
}
module "xy_north" {
  source = "../../modules/triangle"

  material  = local.direction_materials["north"]
  direction = "north"
  plane     = "xy"
  height    = 4
  width     = 4

  start_position = module.south_vectors["B"].end_position
  transform = {
    x = 0
    y = 5
    z = 0
  }
}

module "xy_east" {
  source = "../../modules/triangle"

  material  = local.direction_materials["east"]
  direction = "east"
  plane     = "xy"
  height    = 4
  width     = 4

  start_position = module.south_vectors["B"].end_position
  transform = {
    x = 1
    y = 5
    z = 0
  }
}

module "xy_west" {
  source = "../../modules/triangle"

  material  = local.direction_materials["west"]
  direction = "west"
  plane     = "xy"
  height    = 4
  width     = 4

  start_position = module.south_vectors["B"].end_position
  transform = {
    x = 0
    y = 4
    z = 0
  }
}

module "yz_south" {
  source = "../../modules/triangle"

  material  = local.direction_materials["south"]
  direction = "south"
  plane     = "yz"
  height    = 4
  width     = 4

  start_position = module.south_vectors["C"].end_position
  transform = {
    x = -1
    y = 1
    z = 1
  }
}

module "yz_north" {
  source = "../../modules/triangle"

  material  = local.direction_materials["north"]
  direction = "north"
  plane     = "yz"
  height    = 4
  width     = 4

  start_position = module.south_vectors["C"].end_position
  transform = {
    x = -1
    y = 0
    z = -1
  }
}

module "yz_east" {
  source = "../../modules/triangle"

  material  = local.direction_materials["east"]
  direction = "east"
  plane     = "yz"
  height    = 4
  width     = 4

  start_position = module.south_vectors["C"].end_position
  transform = {
    x = -1
    y = 1
    z = -1
  }
}


module "yz_west" {
  source = "../../modules/triangle"

  material  = local.direction_materials["west"]
  direction = "west"
  plane     = "yz"
  height    = 4
  width     = 4

  start_position = module.south_vectors["C"].end_position
  transform = {
    x = -1
    y = 0
    z = 1
  }
}
