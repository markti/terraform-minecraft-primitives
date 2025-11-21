
module "pyramid_hollow" {
  source = "../../modules/pyramid/hollow"

  material       = "stone"
  length         = 9
  start_position = module.v_cyan2.end_position
  transform = {
    x = 1
    y = 0
    z = 0
  }

}

module "pyramid_hollow_points" {
  source = "../../modules/vector"

  for_each = module.pyramid_hollow.base_position.all

  material       = "minecraft:pink_wool"
  length         = 3
  direction      = "up"
  start_position = each.value
  transform = {
    x = 0
    y = 1
    z = 0
  }
}


module "pyramid_hollow_peak" {
  source = "../../modules/vector"

  for_each = module.pyramid_hollow.peak_position.all

  material       = "minecraft:yellow_wool"
  length         = 3
  direction      = "up"
  start_position = each.value
  transform = {
    x = 0
    y = 1
    z = 0
  }
}

module "pyramid_solid" {
  source = "../../modules/pyramid/solid"

  material       = "stone"
  length         = 9
  start_position = module.pyramid_hollow.base_position.corners.south_west
  transform = {
    x = 0
    y = 0
    z = 1
  }

}
