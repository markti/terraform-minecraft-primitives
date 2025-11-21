

module "v_white" {
  source = "../../modules/vector"

  material = "minecraft:white_wool"
  start_position = {
    x = 486
    y = 64
    z = 142
  }
  length    = 5
  direction = "up"
}

module "v_blue" {
  source = "../../modules/vector"

  material       = "minecraft:blue_wool"
  length         = 3
  direction      = "west"
  start_position = module.v_white.end_position
  transform = {
    x = -1
    y = 0
    z = 0
  }
}

module "v_red" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 3
  direction      = "west"
  start_position = module.v_white.start_position
  transform = {
    x = -1
    y = 0
    z = 0
  }
}

module "v_orange" {
  source = "../../modules/vector"

  material       = "minecraft:orange_wool"
  length         = 3
  direction      = "east"
  start_position = module.v_white.end_position
  transform = {
    x = 1
    y = 0
    z = 0
  }
}

module "v_cyan" {
  source = "../../modules/vector"

  material       = "minecraft:cyan_wool"
  start_position = module.v_white.start_position
  length         = 3
  direction      = "east"
  transform = {
    x = 1
    y = 0
    z = 0
  }
}

module "v_pink" {
  source = "../../modules/vector"

  material       = "minecraft:pink_wool"
  start_position = module.v_orange.end_position
  transform = {
    x = 1
    y = 0
    z = 0
  }
  length    = 5
  direction = "down"
}

module "v_lime" {
  source = "../../modules/vector"

  material       = "minecraft:lime_wool"
  start_position = module.v_blue.end_position
  length         = 5
  direction      = "down"
  transform = {
    x = -1
    y = 0
    z = 0
  }
}

module "v_red_north" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 3
  direction      = "north"
  start_position = module.v_lime.end_position
  transform = {
    x = 0
    y = 0
    z = -1
  }
}

module "v_red_south" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 3
  direction      = "south"
  start_position = module.v_lime.end_position
  transform = {
    x = 0
    y = 0
    z = 1
  }
}


module "v_cyan_north" {
  source = "../../modules/vector"

  material       = "minecraft:cyan_wool"
  length         = 3
  direction      = "north"
  start_position = module.v_pink.end_position
  transform = {
    x = 0
    y = 0
    z = -1
  }
}

module "v_cyan_south" {
  source = "../../modules/vector"

  material       = "minecraft:cyan_wool"
  length         = 3
  direction      = "south"
  start_position = module.v_pink.end_position
  transform = {
    x = 0
    y = 0
    z = 1
  }
}


module "v_cyan2" {
  source = "../../modules/vector"

  material       = "minecraft:cyan_wool"
  start_position = module.v_cyan.end_position
  length         = 10
  direction      = "east"
  transform = {
    x = 1
    y = 0
    z = 0
  }
}
