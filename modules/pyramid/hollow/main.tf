# Inputs:
# var.start_position = CENTER of base (x,y,z)
# var.length >= 2
# var.material

locals {
  base_y       = var.start_position.y
  base_start_x = var.start_position.x - floor(var.length / 2)
  base_start_z = var.start_position.z - floor(var.length / 2)

  layers = flatten([
    for i in range(0, 100) : [
      {
        side    = var.length - 2 * i
        y       = local.base_y + i
        start_x = local.base_start_x + i
        start_z = local.base_start_z + i
      }
    ]
    if var.length - 2 * i >= 2 # need ≥2×2 to draw a frame
  ])
}

# (Optional) solid floor
/*
module "base_floor" {
  source         = "../../cuboid"
  material       = var.material
  start_position = { x = local.base_start_x, y = local.base_y, z = local.base_start_z }
  width          = var.length
  height         = 1
  depth          = var.length
  direction      = "south" # canonical +X/+Z
}
*/

# Horizontal rings rising one block per layer
module "pyramid_sides" {
  source = "../../square-frame"
  count  = 1

  material       = var.material
  start_position = var.start_position

  # For a horizontal ring, X/Z are the span; Y thickness is 1
  width  = var.length # X
  height = 1          # Z
  length = var.length # 1-block slice in Y
  # Either expose plane="horizontal" OR keep direction constant; do NOT extrude sideways
  # plane     = "horizontal"
  direction = "south"
}
