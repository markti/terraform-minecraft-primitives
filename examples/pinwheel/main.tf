
locals {

  direction_materials = {
    north = "copper_block"
    south = "iron_block"
    east  = "gold_block"
    west  = "diamond_block"
  }

  n = 7
  s = local.n - 1

  # Pick the SOUTH-WEST corner of the 2x2 "B hub"
  hub_B_sw = {
    x = 490
    y = 71
    z = 252
  }

  # B targets (2x2 cluster)
  B_targets = {
    east  = local.hub_B_sw
    north = { x = local.hub_B_sw.x + 1, y = local.hub_B_sw.y, z = local.hub_B_sw.z }
    west  = { x = local.hub_B_sw.x + 1, y = local.hub_B_sw.y, z = local.hub_B_sw.z - 1 }
    south = { x = local.hub_B_sw.x, y = local.hub_B_sw.y, z = local.hub_B_sw.z - 1 }
  }

  # Must match triangle module's XZ axes_by_direction
  u_axes = {
    east  = { x = 1, y = 0, z = 0 }
    south = { x = 0, y = 0, z = 1 }
    west  = { x = -1, y = 0, z = 0 }
    north = { x = 0, y = 0, z = -1 }
  }

  # Solve A from B_target:  A = B - u*(n-1)
  A_from_B = {
    for dir, Bt in local.B_targets : dir => {
      x = Bt.x - local.u_axes[dir].x * local.s
      y = Bt.y - local.u_axes[dir].y * local.s
      z = Bt.z - local.u_axes[dir].z * local.s
    }
  }
}

module "triangles" {
  for_each = local.A_from_B
  source   = "../../modules/triangle"

  material       = local.direction_materials[each.key]
  direction      = each.key
  width          = local.n
  height         = local.n
  start_position = each.value
}
