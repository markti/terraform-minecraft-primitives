module "frame_north" {
  source = "../../modules/frame"

  start_position = module.v_cyan_north.end_position
  transform = {
    x = -2
    y = 0
    z = -1
  }
  material  = "stone"
  direction = "north"
  length    = 5
  width     = 5
  height    = 7

}

module "v_frame_north" {
  source = "../../modules/vector"

  for_each = module.frame_north.end_position.all

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

module "frame_north2" {
  source = "../../modules/frame"

  start_position = module.v_frame_north["bottom_left"].end_position
  transform = {
    x = 0
    y = 0
    z = -1
  }
  material  = "stone"
  direction = "north"
  length    = 5
  width     = 5
  height    = 7

}


module "v_frame_north2" {
  source = "../../modules/vector"

  material       = "minecraft:cyan_wool"
  length         = 3
  direction      = "north"
  start_position = module.frame_north2.end_position.side_centers.bottom
  transform = {
    x = 0
    y = 0
    z = -1
  }
}


module "frame_north2_up" {
  source = "../../modules/frame"

  start_position = module.v_frame_north2.end_position
  transform = {
    x = -2
    y = 1
    z = -7
  }
  material  = "stone"
  direction = "up"
  length    = 5
  width     = 5
  height    = 7

}


module "frame_north2_down" {
  source = "../../modules/frame"

  start_position = module.v_frame_north2.end_position
  transform = {
    x = -2
    y = -1
    z = -7
  }
  material  = "stone"
  direction = "down"
  length    = 5
  width     = 5
  height    = 7

}


module "frame_south" {
  source = "../../modules/frame"

  start_position = module.v_cyan_south.end_position
  transform = {
    x = -2
    y = 0
    z = 1
  }
  material  = "stone"
  direction = "south"
  length    = 5
  width     = 5
  height    = 7

}

module "v_frame_south" {
  source = "../../modules/vector"

  material       = "minecraft:red_wool"
  length         = 5
  direction      = "south"
  start_position = module.frame_south.end_position.side_centers.bottom
  transform = {
    x = 0
    y = 0
    z = 1
  }
}

module "frame_south_east" {
  source = "../../modules/frame"

  start_position = module.v_frame_south.end_position
  transform = {
    x = 1
    y = 0
    z = -2
  }
  material  = "stone"
  direction = "east"
  length    = 3
  width     = 5
  height    = 7

}

module "frame_south_west" {
  source = "../../modules/frame"

  start_position = module.v_frame_south.end_position
  transform = {
    x = -1
    y = 0
    z = -2
  }
  material  = "stone"
  direction = "west"
  length    = 3
  width     = 5
  height    = 7

}
