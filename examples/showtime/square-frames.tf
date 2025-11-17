module "frame_north" {
  source = "../../modules/square-frame"

  start_position = module.v_cyan_north.end_position
  transform = {
    x = -2
    y = 0
    z = -1
  }
  material  = "stone"
  direction = "north"
  length    = 5
  width     = 5
  height    = 7

}

module "v_frame_north" {
  source = "../../modules/vector"

  for_each = module.frame_north.end_position.all

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
