module "sphere" {
  source   = "../../modules/sphere"
  material = "gold_block"
  diameter = 8

  start_position = {
    x = 453
    y = 70
    z = 237
  }
}
