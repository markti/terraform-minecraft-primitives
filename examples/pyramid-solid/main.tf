
locals {
  start_position = {
    x = 27
    y = 63
    z = -281
  }
}

/*
module "solid" {
  source = "../../modules/pyramid/solid"

  count = 0

  start_position = local.start_position
  material       = "stone"
  length         = 10

}
*/

module "hollow" {
  source = "../../modules/pyramid/hollow"

  count = 1

  start_position = local.start_position
  material       = "stone"
  length         = 20

}
