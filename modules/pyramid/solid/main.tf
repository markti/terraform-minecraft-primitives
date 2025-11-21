module "transformed_start_position" {
  source = "../../position"

  start_position   = var.start_position
  translate_vector = var.transform
}

locals {
  base_start = module.transformed_start_position.result
  base_size  = var.length

  # side_len(i) = length - 2*i
  # last index i where side_len >= 1:
  #   i_max = floor((length - 1) / 2)
  max_index = floor((var.length - 1) / 2)

  # All levels from base (i=0) to the peak (i=max_index)
  #
  # Example: length = 8
  #   i=0 → side_len=8, y=base_y
  #   i=1 → side_len=6, y=base_y+1
  #   i=2 → side_len=4, y=base_y+2
  #   i=3 → side_len=2, y=base_y+3
  #
  solid_levels = [
    for i in range(0, local.max_index + 1) : {
      idx      = i
      side_len = var.length - 2 * i
      y        = local.base_start.y + i
      x0       = local.base_start.x + i
      z0       = local.base_start.z + i
    }
  ]
}

#############################
# Solid layers (filled squares)
#############################
resource "minecraft_fill" "solid_layers" {
  for_each = {
    for lvl in local.solid_levels : tostring(lvl.idx) => lvl
  }

  material = var.material

  start = {
    x = each.value.x0
    y = each.value.y
    z = each.value.z0
  }

  end = {
    x = each.value.x0 + each.value.side_len - 1
    y = each.value.y
    z = each.value.z0 + each.value.side_len - 1
  }
}
