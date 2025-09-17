
locals {
  start_position = {
    x = -30
    y = 68
    z = -230
  }
}

module "up" {
  source = "../../modules/cuboid"

  count = 1

  start_position = local.start_position
  material       = "stone"
  direction      = "up"
  width          = 10
  depth          = 2
  height         = 2

}

module "cube_bottom" {
  source    = "../../modules/cuboid"
  material  = "minecraft:stone"
  direction = "down"

  # same X,Z as pillar; Y starts one block below the base
  start_position = {
    x = local.start_position.x
    y = local.start_position.y - 1
    z = local.start_position.z
  }

  width  = 2 # along -Y (down)
  depth  = 2 # along +X
  height = 2 # along +Z
}

# North (Z - 2)
module "pos_north" {
  source         = "../../modules/position"
  start_position = local.start_position
  translate_vector = {
    x = 0
    y = 0
    z = -1
  }
}

# South (Z + 2)
module "pos_south" {
  source         = "../../modules/position"
  start_position = local.start_position
  translate_vector = {
    x = 0
    y = 0
    z = 2
  }
}

# West (X - 2)
module "pos_west" {
  source         = "../../modules/position"
  start_position = local.start_position
  translate_vector = {
    x = -1
    y = 0
    z = 0
  }
}

# East (X + 2)
module "pos_east" {
  source         = "../../modules/position"
  start_position = local.start_position
  translate_vector = {
    x = 2
    y = 0
    z = 0
  }
}

# --- Four 2x2x2 cubes, one on each side ---

module "cube_north" {
  source         = "../../modules/cuboid"
  start_position = module.pos_north.result
  material       = "minecraft:stone"
  direction      = "north"
  width          = 2 # along -Z
  depth          = 2 # along +X
  height         = 2 # along +Y
}

module "cube_south" {
  source         = "../../modules/cuboid"
  start_position = module.pos_south.result
  material       = "minecraft:stone"
  direction      = "south"
  width          = 2 # along +Z
  depth          = 2 # along +X
  height         = 2 # along +Y
}

module "cube_west" {
  source         = "../../modules/cuboid"
  start_position = module.pos_west.result
  material       = "minecraft:stone"
  direction      = "west"
  width          = 2 # along -X
  depth          = 2 # along +Z
  height         = 2 # along +Y
}

module "cube_east" {
  source         = "../../modules/cuboid"
  start_position = module.pos_east.result
  material       = "minecraft:stone"
  direction      = "east"
  width          = 2 # along +X
  depth          = 2 # along +Z
  height         = 2 # along +Y
}
