module "microsoft_logo" {
  source = "./modules/microsoft-logo"

  start_position = module.castle_turret2.start_position.bottom
  transform = {
    x = 0
    y = 0
    z = -20
  }
  length         = 5
  pedestal_depth = 5
}
