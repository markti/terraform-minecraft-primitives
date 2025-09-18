
locals {
  start_position = {
    x = -24
    y = 65
    z = -236
  }
}

module "stairs" {
  source = "../../modules/stairs"

  count = 1

  start_position = local.start_position
  material       = "stone"
  direction      = "east"
  width          = 6
  height         = 10
  vertical       = "ascending"
  taper          = false

}

module "stair_pos" {
  source         = "../../modules/position"
  start_position = local.start_position
  translate_vector = {
    x = -1
    y = 0
    z = 0
  }
}

module "first_tread" {
  source = "../../modules/stair-tread"

  material                 = "stone_stairs"
  direction                = "east"
  width                    = 4
  start_position           = module.stair_pos.result
  enable_start_left_corner = true
  enable_end_right_corner  = true
  corner_shape_swap        = false

}
