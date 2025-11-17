module "cube_3" {
  source = "../../modules/cuboid"

  material  = "stone"
  direction = "east"
  transform = {
    x = 1 + 2
    y = 0
    z = 0
  }

  start_position = module.pyramid_hollow.base_position.side_centers.east

  width  = 3
  depth  = 3
  height = 3
}

module "cube_4" {
  source = "../../modules/cuboid"

  material  = "stone"
  direction = "east"
  transform = {
    x = 1 + 1
    y = 0
    z = 0
  }

  start_position = module.cube_3.edges["bottom_east"].center

  width  = 4
  depth  = 4
  height = 4
}

module "cube_5" {
  source = "../../modules/cuboid"

  material  = "stone"
  direction = "east"
  transform = {
    x = 1 + 1
    y = 0
    z = 0
  }

  start_position = module.cube_4.edges["bottom_east"].center

  width  = 5
  depth  = 5
  height = 5
}

