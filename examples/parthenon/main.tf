module "main" {
  source = "../../modules/parthenon"

  start_position = {
    x = 434
    y = 68
    z = 272
  }

  ziggurat = {
    material = "stone"
    width    = 21
    height   = 4
    length   = 17
  }

  temple = {
    # leave null to auto-fit to top surface
    length = null
    width  = null

    stylobate_height   = 2
    column_height      = 9
    column_spacing     = 2
    column_inset       = 0
    entablature_height = 2
    roof_height        = 3

    materials = {
      stylobate   = "smooth_quartz"
      columns     = "quartz_pillar"
      entablature = "smooth_quartz"
      roof        = "stone_bricks"
    }
  }
}
