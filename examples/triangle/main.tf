locals {
  point_colors = {
    A = "red_wool"
    B = "white_wool"
    C = "blue_wool"
  }
}


module "east" {
  source = "../../modules/triangle"

  material  = "diamond_block"
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

  material  = "diamond_block"
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

  material  = "diamond_block"
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

  material  = "diamond_block"
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
