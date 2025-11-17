
module "volcano" {
  source = "../../modules/pyramid/solid"

  material       = "minecraft:basalt"
  length         = 31
  start_position = module.cube_5.edges["bottom_east"].center
  transform = {
    x = 1 + 20
    y = -2
    z = 1
  }

}

resource "minecraft_block" "lava_peak" {
  material = "minecraft:lava"

  position = {
    x = module.volcano.peak_position.center.x
    y = module.volcano.peak_position.center.y
    z = module.volcano.peak_position.center.z
  }
}

/*
locals {
  # Use base layer (index 0) to determine overall X/Z bounds + base Y
  volcano_base_layer = module.volcano.layer_ranges[0]

  volcano_min_x  = local.volcano_base_layer.min_x
  volcano_max_x  = local.volcano_base_layer.max_x
  volcano_min_z  = local.volcano_base_layer.min_z
  volcano_max_z  = local.volcano_base_layer.max_z
  volcano_base_y = local.volcano_base_layer.y

  # Filter exterior blocks by side.
  # Skip the base layer (y > base_y) so vents aren't on the ground.
  north_blocks = [
    for b in module.volcano.exterior_blocks :
    b if b.z == local.volcano_min_z && b.y > local.volcano_base_y
  ]

  south_blocks = [
    for b in module.volcano.exterior_blocks :
    b if b.z == local.volcano_max_z && b.y > local.volcano_base_y
  ]

  west_blocks = [
    for b in module.volcano.exterior_blocks :
    b if b.x == local.volcano_min_x && b.y > local.volcano_base_y
  ]

  east_blocks = [
    for b in module.volcano.exterior_blocks :
    b if b.x == local.volcano_max_x && b.y > local.volcano_base_y
  ]
}

resource "random_integer" "lava_north" {
  count = length(local.north_blocks) > 0 ? 1 : 0
  min   = 0
  max   = length(local.north_blocks) - 1
}

resource "random_integer" "lava_south" {
  count = length(local.south_blocks) > 0 ? 1 : 0
  min   = 0
  max   = length(local.south_blocks) - 1
}

resource "random_integer" "lava_west" {
  count = length(local.west_blocks) > 0 ? 1 : 0
  min   = 0
  max   = length(local.west_blocks) - 1
}

resource "random_integer" "lava_east" {
  count = length(local.east_blocks) > 0 ? 1 : 0
  min   = 0
  max   = length(local.east_blocks) - 1
}

resource "minecraft_block" "lava_north" {
  count    = length(random_integer.lava_north)
  material = "minecraft:lava"

  position = local.north_blocks[random_integer.lava_north[count.index].result]
}

resource "minecraft_block" "lava_south" {
  count    = length(random_integer.lava_south)
  material = "minecraft:lava"

  position = local.south_blocks[random_integer.lava_south[count.index].result]
}

resource "minecraft_block" "lava_west" {
  count    = length(random_integer.lava_west)
  material = "minecraft:lava"

  position = local.west_blocks[random_integer.lava_west[count.index].result]
}

resource "minecraft_block" "lava_east" {
  count    = length(random_integer.lava_east)
  material = "minecraft:lava"

  position = local.east_blocks[random_integer.lava_east[count.index].result]
}
*/
