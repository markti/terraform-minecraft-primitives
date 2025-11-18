module "transformed_start_position" {
  source = "../../../../modules/position"

  start_position   = var.start_position
  translate_vector = var.transform
}

# Map which physical axes are the cross-section for each direction.
# - primary = axis the frame runs along (length = depth)
# - cx = first perpendicular axis used by width
# - cy = second perpendicular axis used by height
# Signs are chosen so increasing width/height goes outward in + direction.
locals {
  start_position = module.transformed_start_position.result

  # Width (along X) still based on the logo geometry:
  # 1 margin + L + 1 gap + L + 1 margin = 2L + 3
  platform_width_x = var.length * 2 + 3

  # Use input values directly
  platform_depth_z  = var.pedestal_depth
  platform_height_y = var.pedestal_height

  # Middle Z block of the pedestal (logo hangs above here)
  logo_z = local.start_position.z + floor(var.pedestal_depth / 2)

  # Logo bottom Y: pedestal top + 1 block hover
  logo_y_bottom = local.start_position.y + var.pedestal_height + 1

  # X positioning: start 1 block in from west edge
  logo_x_min = local.start_position.x + 1
}

#############################
# 1) Wooden pedestal (square)
#############################
module "logo_pedestal" {
  source = "../../../../modules/cuboid"

  material  = "oak_planks"
  direction = "up"

  # bottom-north-west corner
  start_position = local.start_position

  # For direction = "up":
  #   width  = along +Y (thickness)
  #   depth  = along +X
  #   height = along +Z
  width  = local.platform_height_y
  depth  = local.platform_width_x
  height = local.platform_depth_z
}

#############################
# 2) Microsoft logo – four wool squares
# For direction = "east":
#   width  = along +X (thickness)
#   depth  = along +Z (horizontal span)
#   height = along +Y (vertical span)
#############################

# 🔵 Bottom-left (Blue)
module "logo_blue" {
  source    = "../../../../modules/cuboid"
  material  = "light_blue_wool"
  direction = "south"

  start_position = {
    x = local.logo_x_min
    y = local.logo_y_bottom
    z = local.logo_z
  }

  width  = 1          # thickness along Z
  depth  = var.length # X span
  height = var.length # Y span
}

# 🟨 Bottom-right (Yellow)
module "logo_yellow" {
  source    = "../../../../modules/cuboid"
  material  = "yellow_wool"
  direction = "south"

  start_position = {
    x = local.logo_x_min + var.length + 1
    y = local.logo_y_bottom
    z = local.logo_z
  }

  width  = 1
  depth  = var.length
  height = var.length
}

# 🔴 Top-left (Red)
module "logo_red" {
  source    = "../../../../modules/cuboid"
  material  = "red_wool"
  direction = "south"

  start_position = {
    x = local.logo_x_min
    y = local.logo_y_bottom + var.length + 1
    z = local.logo_z
  }

  width  = 1
  depth  = var.length
  height = var.length
}


# 🟩 Top-right (Green)
module "logo_green" {
  source    = "../../../../modules/cuboid"
  material  = "lime_wool"
  direction = "south"

  start_position = {
    x = local.logo_x_min + var.length + 1
    y = local.logo_y_bottom + var.length + 1
    z = local.logo_z
  }

  width  = 1
  depth  = var.length
  height = var.length
}
