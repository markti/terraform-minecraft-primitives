
locals {
  diameter = 6
}

module "tube_north" {
  source = "../../modules/tube"

  material  = "stone"
  direction = "north"
  diameter  = local.diameter
  depth     = 9

  start_position = {
    x = 604
    y = 79
    z = 314
  }
  transform = {
    x = 0
    y = local.diameter / 2
    z = 0
  }

}


module "north_start_connectors" {
  source = "../../modules/vector"

  for_each = module.tube_north.start_position.all

  material       = "minecraft:magenta_wool"
  length         = 3
  direction      = "south"
  start_position = each.value
  transform = {
    x = 0
    y = 0
    z = 1
  }
}


module "north_end_connectors" {
  source = "../../modules/vector"

  for_each = module.tube_north.end_position.all

  material       = "minecraft:cyan_wool"
  length         = 3
  direction      = "north"
  start_position = each.value
  transform = {
    x = 0
    y = 0
    z = -1
  }
}

module "tube_north_long" {
  source = "../../modules/tube"

  material  = "glass"
  direction = "south"
  diameter  = local.diameter
  depth     = 190

  start_position = module.north_start_connectors["center"].end_position
  transform = {
    x = 0
    y = 0
    z = 1
  }

}
