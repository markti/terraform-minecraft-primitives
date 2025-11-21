
module "white" {
  source = "../../modules/vector"

  material  = "minecraft:white_wool"
  length    = 5
  direction = "up"
  start_position = {
    x = 486
    y = 64
    z = 142
  }
}

module "blue" {
  source = "../../modules/vector"

  material       = "minecraft:blue_wool"
  length         = 3
  direction      = "west"
  start_position = module.white.end_position
  transform = {
    x = -1
    y = 0
    z = 0
  }
}

module "red" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 3
  direction      = "east"
  start_position = module.white.end_position
  transform = {
    x = 1
    y = 0
    z = 0
  }
}


module "green" {
  source = "../../modules/vector"

  material       = "minecraft:green_wool"
  length         = 3
  direction      = "north"
  start_position = module.white.end_position
  transform = {
    x = 0
    y = 0
    z = -1
  }
}

module "yellow" {
  source = "../../modules/vector"

  material       = "minecraft:yellow_wool"
  length         = 3
  direction      = "south"
  start_position = module.white.end_position
  transform = {
    x = 0
    y = 0
    z = 1
  }
}
