
module "castle_turret1" {
  source = "../../modules/tube"

  start_position = module.volcano.base_position.corners.south_west
  transform = {
    x = 0
    y = 5
    z = 35
  }
  material  = "stone"
  direction = "up"
  diameter  = 10
  depth     = 10

}

module "south_wall" {
  source = "../../modules/frame"

  height = 6
  width  = 5
  length = 30

  start_position = module.castle_turret1.start_position.right
  transform = {
    x = 1
    y = 0
    z = -2
  }
  material  = "stone"
  direction = "east"
}

module "castle_turret2" {
  source = "../../modules/tube"

  start_position = module.south_wall.end_position.side_centers.bottom
  transform = {
    x = 5
    y = 0
    z = 0
  }
  material  = "stone"
  direction = "up"
  diameter  = 10
  depth     = 10

}
