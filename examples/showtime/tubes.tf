module "tube_north" {
  source = "../../modules/tube"

  count = 1

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

module "tube_south" {
  source = "../../modules/tube"

  count = 1

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
