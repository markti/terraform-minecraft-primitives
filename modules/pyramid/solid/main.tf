# CENTERED, direction-agnostic pyramid
# Assumes var.start_position is the CENTER of the base.
locals {
  layers = flatten([
    for i in range(0, 100) : [
      {
        side = var.length - 2 * i
        y    = var.start_position.y + i

        # Compute SW (minX, minZ) so the layer is centered around the given center.
        # Using floor(side/2) gives correct odd (1-block top) and even (2x2 top) behavior.
        start_x = var.start_position.x - floor((var.length - 2 * i) / 2)
        start_z = var.start_position.z - floor((var.length - 2 * i) / 2)
      }
    ]
    if var.length - 2 * i >= 1
  ])
}

module "pyramid_layers" {
  for_each = { for i, layer in local.layers : "layer_${i}" => layer }

  source   = "../../cuboid"
  material = var.material

  start_position = {
    x = each.value.start_x
    y = each.value.y
    z = each.value.start_z
  }

  width  = each.value.side # along +X
  height = 1
  depth  = each.value.side # along +Z

  # Force a canonical orientation so the cuboid always grows +X/+Z.
  direction = "south"
}
