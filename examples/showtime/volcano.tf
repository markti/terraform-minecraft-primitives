
module "volcano" {
  source = "../../modules/pyramid/solid"

  material       = "minecraft:basalt"
  length         = 21
  start_position = module.cube_5.edges["bottom_east"].center
  transform = {
    x = 1 + 20
    y = 0
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
