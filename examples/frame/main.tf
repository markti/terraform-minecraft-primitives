module "north" {
  source = "../../modules/frame"

  material  = "stone"
  direction = "north"
  width     = 5
  height    = 7
  depth     = 3

  start_position = {
    x = 486
    y = 64
    z = 142
  }

}

module "north_end_connectors" {
  source = "../../modules/vector"

  for_each = module.north.end_position.all

  material       = "minecraft:cyan_wool"
  length         = 3
  direction      = "north"
  start_position = each.value
  transform = {
    x = 0
    y = 0
    z = -1
  }
}

module "north_start_connectors" {
  source = "../../modules/vector"

  for_each = module.north.start_position.all

  material       = "minecraft:magenta_wool"
  length         = 3
  direction      = "south"
  start_position = each.value
  transform = {
    x = 0
    y = 0
    z = 1
  }
}

module "north_mid_connectors" {
  source = "../../modules/vector"

  for_each = module.north.mid_position.all

  material       = "minecraft:yellow_wool"
  length         = 3
  direction      = "east"
  start_position = each.value
  transform = {
    x = 0
    y = 0
    z = 0
  }
}
