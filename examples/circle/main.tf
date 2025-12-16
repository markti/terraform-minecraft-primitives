
module "diamond" {
  source = "../../modules/circle"

  material  = "diamond_block"
  direction = "east"
  diameter  = 7

  start_position = {
    x = 576
    y = 83
    z = 315
  }

}

module "diamond_end_connectors" {
  source = "../../modules/vector"

  for_each = module.diamond.start_position.all

  material       = "minecraft:cyan_wool"
  length         = 3
  direction      = "east"
  start_position = each.value

  transform = {
    x = 1
    y = 0
    z = 0
  }
}

module "diamond_start_connectors" {
  source = "../../modules/vector"

  for_each = module.diamond.start_position.all

  material       = "minecraft:magenta_wool"
  length         = 3
  direction      = "west"
  start_position = each.value

  transform = {
    x = -1
    y = 0
    z = 0
  }
}
