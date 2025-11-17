module "frame_north" {
  source = "../../modules/square-frame"

  start_position = module.v_cyan_north.end_position
  transform = {
    x = 0
    y = 0
    z = -1
  }
  material  = "stone"
  direction = "north"
  length    = 5
  width     = 5
  height    = 5

}
