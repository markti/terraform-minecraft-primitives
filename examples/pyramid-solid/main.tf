
locals {
  start_position = {
    x = 572
    y = 68
    z = 230
  }
}

module "square_frame" {
  source = "../../modules/frame"

  count = 1

  start_position = local.start_position
  material       = "stone"
  width          = 10
  height         = 1
  length         = 10
  direction      = "north"
}


module "solid" {
  source = "../../modules/pyramid/solid"

  count = 0

  start_position = local.start_position
  material       = "stone"
  length         = 10

}


module "hollow" {
  source = "../../modules/pyramid/hollow"

  count = 0

  start_position = local.start_position
  material       = "stone"
  length         = 20

}
