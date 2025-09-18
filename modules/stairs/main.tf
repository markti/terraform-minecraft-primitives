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

locals {
  vstep = var.vertical == "descending" ? -1 : 1

  # draw across the perpendicular (to run) axis
  width_direction = (
    local.right_vec.x == 1 ? "east" :
    local.right_vec.x == -1 ? "west" :
    local.right_vec.z == 1 ? "south" : "north"
  )

  # how many steps until we first hit the minimum width (include that step)
  taper_steps = ceil((var.width - var.min_final_width) / 2) + 1

  # final count of steps to build
  effective_steps = var.taper ? min(var.height, local.taper_steps) : var.height

  # per-step specs for for_each (string keys)
  step_specs = {
    for i in range(local.effective_steps) :
    tostring(i) => {
      idx = i
      # remove 1 from each side -> shrink by 2 per step; clamp to min at the last step
      len = var.taper ? max(var.min_final_width, var.width - 2 * i) : var.width
      # center tread: shift start LEFT by floor(len/2), then draw 'len' to the RIGHT
      shift = floor((var.taper ? max(var.min_final_width, var.width - 2 * i) : var.width) / 2)
    }
  }
}


# Build each tread as a perpendicular vector line.
# Step i is i blocks higher (y+i) and i blocks 'back' along the run direction.
module "step" {
  for_each = local.step_specs
  source   = "../vector" # <-- your vector module path

  material  = var.material
  direction = local.width_direction
  length    = each.value.len

  start_position = {
    x = var.start_position.x + local.run_vec.x * each.value.idx + local.left_vec.x * each.value.shift
    y = var.start_position.y + local.vstep * each.value.idx
    z = var.start_position.z + local.run_vec.z * each.value.idx + local.left_vec.z * each.value.shift
  }
}
