
locals {
  start_position = {
    x = -24
    y = 68
    z = -244
  }
}

module "up" {
  source = "../../modules/tube"

  count = 1

  start_position = local.start_position
  material       = "stone"
  direction      = "up"
  diameter       = 6
  depth          = 10

}
