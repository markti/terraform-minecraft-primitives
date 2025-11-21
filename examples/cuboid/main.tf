
module "diamond" {
  source = "../../modules/cuboid"

  material  = "diamond_block"
  direction = "east"
  width     = 3
  depth     = 3
  height    = 3

  start_position = {
    x = 486
    y = 64
    z = 142
  }

}

module "gold" {
  source = "../../modules/cuboid"

  material       = "gold_block"
  direction      = "east"
  width          = 4
  depth          = 4
  height         = 4
  start_position = module.diamond.edges["bottom_east"].center

  transform = {
    x = 1 + 1
    y = 0
    z = 0
  }

}

module "iron" {
  source = "../../modules/cuboid"

  material       = "iron_block"
  direction      = "east"
  width          = 5
  depth          = 5
  height         = 5
  start_position = module.gold.edges["bottom_east"].center

  transform = {
    x = 1 + 1
    y = 0
    z = 0
  }

}

module "copper" {
  source = "../../modules/cuboid"

  material       = "copper_block"
  direction      = "east"
  width          = 6
  depth          = 6
  height         = 6
  start_position = module.iron.edges["bottom_east"].center

  transform = {
    x = 1 + 1
    y = 0
    z = 0
  }

}
