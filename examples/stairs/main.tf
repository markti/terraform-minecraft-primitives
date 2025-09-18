
locals {
  start_position = {
    x = -24
    y = 65
    z = -238
  }
}

module "stairs" {
  source = "../../modules/stairs"

  count = 1

  start_position = local.start_position
  material       = "stone"
  direction      = "east"
  width          = 4
  height         = 10
  vertical       = "descending"

}
