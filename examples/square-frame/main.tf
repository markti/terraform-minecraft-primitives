
locals {
  start_position = {
    x = -22
    y = 65
    z = -232
  }
}

module "up" {
  source = "../../../modules/frame"

  count = 1

  start_position = local.start_position
  material       = "stone"
  direction      = "east"
  width          = 5
  height         = 5
  depth          = 100

}
