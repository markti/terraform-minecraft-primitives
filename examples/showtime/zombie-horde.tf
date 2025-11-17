locals {
  castle_center = {
    x = floor((
      module.castle_turret1.start_center.x +
      module.castle_turret2.start_center.x +
      module.castle_turret3.start_center.x +
      module.castle_turret4.start_center.x
    ) / 4)

    # put them at ground-ish level inside the courtyard
    y = module.castle_turret1.start_center.y

    z = floor((
      module.castle_turret1.start_center.z +
      module.castle_turret2.start_center.z +
      module.castle_turret3.start_center.z +
      module.castle_turret4.start_center.z
    ) / 4)
  }

  # 3x3 grid around the center
  baby_zombie_horde_positions = {
    x = local.castle_center.x
    y = local.castle_center.y + 3
    z = local.castle_center.z
  }

}

resource "minecraft_entity" "baby_zombie_horde" {

  type = "minecraft:zombie"

  count = 100

  position = local.baby_zombie_horde_positions
}
