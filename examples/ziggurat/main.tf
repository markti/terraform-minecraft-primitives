module "main" {
  source = "../../modules/ziggurat"

  material = "stone"
  width    = 8
  height   = 4
  length   = 6

  start_position = {
    x = 491
    y = 112
    z = 313
  }

}
