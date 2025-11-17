module "tube_north" {
  source = "../../modules/tube"

  start_position = module.v_red_north.end_position
  transform = {
    x = 0
    y = 3
    z = -1
  }
  material  = "stone"
  direction = "north"
  diameter  = 6
  depth     = 5

}

module "v_red_north_bottom" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 3
  direction      = "north"
  start_position = module.tube_north.end_position.bottom
  transform = {
    x = 0
    y = 0
    z = -1
  }
}
module "v_red_north_top" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 3
  direction      = "north"
  start_position = module.tube_north.end_position.top
  transform = {
    x = 0
    y = 0
    z = -1
  }
}
module "v_red_north_left" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 3
  direction      = "north"
  start_position = module.tube_north.end_position.left
  transform = {
    x = 0
    y = 0
    z = -1
  }
}
module "v_red_north_right" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 3
  direction      = "north"
  start_position = module.tube_north.end_position.right
  transform = {
    x = 0
    y = 0
    z = -1
  }
}
module "v_red_north_center" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 3
  direction      = "north"
  start_position = module.tube_north.end_position.center
  transform = {
    x = 0
    y = 0
    z = -1
  }
}

module "tube_north2" {
  source = "../../modules/tube"

  start_position = module.v_red_north_center.end_position
  transform = {
    x = 0
    y = 0
    z = -1
  }
  material  = "stone"
  direction = "north"
  diameter  = 6
  depth     = 5

}

module "v_red_north2_bottom" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 3
  direction      = "north"
  start_position = module.tube_north2.end_position.bottom
  transform = {
    x = 0
    y = 0
    z = -1
  }
}


module "tube_north2_up" {
  source = "../../modules/tube"

  start_position = module.v_red_north2_bottom.end_position
  transform = {
    x = 0
    y = 1
    z = -4
  }
  material  = "stone"
  direction = "up"
  diameter  = 6
  depth     = 5

}


module "tube_north2_down" {
  source = "../../modules/tube"

  start_position = module.v_red_north2_bottom.end_position
  transform = {
    x = 0
    y = -1
    z = -4
  }
  material  = "stone"
  direction = "down"
  diameter  = 6
  depth     = 5

}

module "tube_south" {
  source = "../../modules/tube"

  start_position = module.v_red_south.end_position
  transform = {
    x = 0
    y = 3
    z = 1
  }
  material  = "stone"
  direction = "south"
  diameter  = 6
  depth     = 5

}

module "v_red_south_bottom" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 5
  direction      = "south"
  start_position = module.tube_south.end_position.bottom
  transform = {
    x = 0
    y = 0
    z = 1
  }
}

module "tube_south_east" {
  source = "../../modules/tube"

  start_position = module.v_red_south_bottom.end_position
  transform = {
    x = 1
    y = 3
    z = 0
  }
  material  = "stone"
  direction = "east"
  diameter  = 6
  depth     = 3

}

module "tube_south_west" {
  source = "../../modules/tube"

  start_position = module.v_red_south_bottom.end_position
  transform = {
    x = -1
    y = 3
    z = 0
  }
  material  = "stone"
  direction = "west"
  diameter  = 6
  depth     = 3

}
