locals {
  # Row runs PERPENDICULAR to the stair facing
  base_row_vec = contains(["east", "west"], var.direction) ? { x = 0, z = 1 } : { x = 1, z = 0 }
  row_vec      = var.row_invert ? { x = -local.base_row_vec.x, z = -local.base_row_vec.z } : local.base_row_vec

  # Unit offsets one block to the left/right of the *facing*
  right_vec = {
    north = { x = 1, z = 0 }  # east
    east  = { x = 0, z = 1 }  # south
    south = { x = -1, z = 0 } # west
    west  = { x = 0, z = -1 } # north
  }[var.direction]

  left_vec = {
    north = { x = -1, z = 0 } # west
    east  = { x = 0, z = -1 } # north
    south = { x = 1, z = 0 }  # east
    west  = { x = 0, z = 1 }  # south
  }[var.direction]

  # Map to cardinal strings (no functions needed)
  left_dir_map = {
    north = "west"
    east  = "south"
    south = "east"
    west  = "north"
  }
  right_dir_map = {
    north = "east"
    east  = "north"
    south = "west"
    west  = "south"
  }
  left_dir  = local.left_dir_map[var.direction]
  right_dir = local.right_dir_map[var.direction]

  # Far end of the straight run (width = number of blocks in the row)
  end_pos = {
    x = var.start_position.x + local.row_vec.x * (var.width - 1)
    y = var.start_position.y
    z = var.start_position.z + local.row_vec.z * (var.width - 1)
  }

  # Corner positions: one block to the side of start/end (no forward/back)
  start_left_pos  = { x = var.start_position.x + local.left_vec.x, y = var.start_position.y, z = var.start_position.z + local.left_vec.z }
  start_right_pos = { x = var.start_position.x + local.right_vec.x, y = var.start_position.y, z = var.start_position.z + local.right_vec.z }
  end_left_pos = {
    x = var.start_position.x + local.left_vec.x,
    y = var.start_position.y,
    z = var.start_position.z + local.left_vec.z
  }
  end_right_pos = {
    x = local.end_pos.x + local.right_vec.x,
    y = local.end_pos.y,
    z = local.end_pos.z + local.right_vec.z
  }

  # If your provider mirrors these, swap them
  left_shape  = "outer_left"  # "outer_right"
  right_shape = "outer_right" # "outer_left"
}

# --- Straight row (width blocks) ---
resource "minecraft_stairs" "straight" {
  count    = var.width
  material = var.material
  half     = var.half
  facing   = var.direction
  shape    = "straight"

  position = {
    x = var.start_position.x + local.row_vec.x * count.index
    y = var.start_position.y
    z = var.start_position.z + local.row_vec.z * count.index
  }
}

# --- Optional corners (start side) ---
resource "minecraft_stairs" "start_left" {
  count    = var.enable_start_left_corner ? 1 : 0
  material = var.material
  half     = var.half
  facing   = local.left_dir
  shape    = local.left_shape
  position = local.start_left_pos
}

# --- Optional corners (end side) ---
resource "minecraft_stairs" "end_right" {
  count = var.enable_end_right_corner ? 1 : 0

  material = var.material
  half     = var.half
  facing   = local.right_dir
  shape    = local.right_shape
  position = local.end_right_pos
}
