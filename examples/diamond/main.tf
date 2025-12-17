
module "diamond" {
  source = "../../modules/diamond"

  material  = "diamond_block"
  direction = "east"
  height    = 7
  width     = 7

  start_position = {
    x = 489
    y = 83
    z = 273
  }

}

module "diamond2" {
  source = "../../modules/diamond"

  material  = "diamond_block"
  direction = "east"
  height    = 13
  width     = 13

  start_position = module.diamond.origin

  transform = {
    x = 10
    y = 0
    z = 0
  }
}
