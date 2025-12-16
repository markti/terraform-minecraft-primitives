
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
  triangle_points = {
    A = module.east.points.A
    //B = module.east.points.B
    C = module.east.points.C
  }
}

module "triangle_up_vectors" {
  source = "../../modules/vector"

  for_each = local.triangle_points

  material       = "minecraft:yellow_wool"
  length         = 3
  direction      = "up"
  start_position = each.value

  transform = {
    x = 0
    y = 1
    z = 0
  }
}

/*
locals {
  start_point = "A"
}

module "west" {
  source = "../../modules/triangle"

  material  = "diamond_block"
  direction = "west"
  height    = 7
  width     = 7

  start_position = module.east.points[local.start_point]

}

module "south" {
  source = "../../modules/triangle"

  material  = "diamond_block"
  direction = "south"
  height    = 7
  width     = 7

  start_position = module.east.points[local.start_point]

}

module "north" {
  source = "../../modules/triangle"

  material  = "diamond_block"
  direction = "north"
  height    = 7
  width     = 7

  start_position = module.east.points[local.start_point]

}
*/
