
locals {
  start_position = {
    x = -30
    y = 76
    z = -230
  }
}

module "up" {
  source = "../../modules/vector"

  count = 1

  start_position = local.start_position
  material       = "stone"
  direction      = "up"
  length         = 10

}


module "down_start_position" {
  source         = "../../modules/position"
  start_position = local.start_position
  translate_vector = {
    x = 0
    y = -1
    z = 0
  }
}


module "down" {
  source = "../../modules/vector"

  count = 1

  start_position = module.down_start_position.result
  material       = "stone"
  direction      = "down"
  length         = 10

}


module "north_start_position" {
  source         = "../../modules/position"
  start_position = local.start_position
  translate_vector = {
    x = 0
    y = 0
    z = -1
  }

}

module "north" {

  count = 1

  source = "../../modules/vector"

  start_position = module.north_start_position.result
  material       = "minecraft:oak_planks"
  direction      = "north"
  length         = 3

}


module "south_start_position" {
  source         = "../../modules/position"
  start_position = local.start_position
  translate_vector = {
    x = 0
    y = 0
    z = 1
  }

}


module "south" {
  source = "../../modules/vector"

  start_position = module.south_start_position.result
  material       = "minecraft:jungle_planks"
  direction      = "south"
  length         = 3

}

module "east_start_position" {
  source         = "../../modules/position"
  start_position = local.start_position
  translate_vector = {
    x = 1
    y = 0
    z = 0
  }

}

module "east" {
  source = "../../modules/vector"

  start_position = module.east_start_position.result
  material       = "minecraft:acacia_planks"
  direction      = "east"
  length         = 3

}


module "west_start_position" {
  source         = "../../modules/position"
  start_position = local.start_position
  translate_vector = {
    x = -1
    y = 0
    z = 0
  }

}

module "west" {
  source = "../../modules/vector"

  count = 1

  start_position = module.west_start_position.result
  material       = "minecraft:dark_oak_planks"
  direction      = "west"
  length         = 3

}
