locals {

  # Unit vectors for the run direction (move 'back' one per step)
  run_vec = {
    north = { x = 0, z = -1 }
    south = { x = 0, z = 1 }
    east  = { x = 1, z = 0 }
    west  = { x = -1, z = 0 }
  }[var.direction]

  # Perpendicular unit vectors: right and left relative to the run
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

  # Lateral offset to center width (biases half-width to the "left")
  half_width_left = floor(var.width / 2)
}

# Build each tread as a perpendicular vector line.
# Step i is i blocks higher (y+i) and i blocks 'back' along the run direction.
module "step" {
  for_each = { for i in range(var.height) : tostring(i) => i }
  source   = "../vector" # <-- update to your actual path

  material = var.material
  direction = (
    # Draw the tread across the width in the "right" direction
    # (length = var.width; start is pre-shifted left when centering)
    # If you want the width to extend left instead, swap right_vec with left_vec here.
    local.right_vec.x == 1 ? "east" :
    local.right_vec.x == -1 ? "west" :
    local.right_vec.z == 1 ? "south" : "north"
  )
  length = var.width

  start_position = {
    x = var.start_position.x + local.run_vec.x * each.value
    y = var.start_position.y + each.value
    z = var.start_position.z + local.run_vec.z * each.value
  }
}
