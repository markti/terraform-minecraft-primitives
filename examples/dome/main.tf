module "sphere" {
  source   = "../../modules/dome"
  material = "gold_block"
  diameter = 8

  start_position = {
    x = 470
    y = 70
    z = 237
  }
}
