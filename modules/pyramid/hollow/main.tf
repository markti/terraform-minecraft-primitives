module "transformed_start_position" {
  source = "../../position"

  start_position   = var.start_position
  translate_vector = var.transform
}

locals {
  base_start = module.transformed_start_position.result
  base_size  = var.length

  # For the very top:
  # - odd base: 1×1 top
  # - even base: 2×2 top
  cap_size = var.length % 2 == 1 ? 1 : 2

  # The index of the *top* layer (cap)
  # side_len(i) = length - 2*i
  max_index = floor((var.length - local.cap_size) / 2)

  # Frames should start at i = 1 (inset by 1 block from each side),
  # and stop at i = max_index - 1 (the top index is reserved for the cap).
  #
  # Example: length = 8 (cap_size = 2, max_index = 3)
  #   base    8x8
  #   i=1     6x6  (frame)
  #   i=2     4x4  (frame)
  #   i=3     2x2  (cap)
  #
  frame_levels = [
    for i in range(1, local.max_index) : {
      idx      = i
      side_len = var.length - 2 * i
      y        = local.base_start.y + i
      x0       = local.base_start.x + i
      z0       = local.base_start.z + i
    }
  ]

  # Top cap sits at index = max_index
  top_cap_layer = {
    side_len = var.length - 2 * local.max_index
    y        = local.base_start.y + local.max_index
    x0       = local.base_start.x + local.max_index
    z0       = local.base_start.z + local.max_index
  }
}

#############################
# 1) Solid base floor (8×8)
#############################
resource "minecraft_fill" "base_floor" {
  material = var.material

  start = {
    x = local.base_start.x
    y = local.base_start.y
    z = local.base_start.z
  }

  end = {
    x = local.base_start.x + local.base_size - 1
    y = local.base_start.y
    z = local.base_start.z + local.base_size - 1
  }
}

#############################
# 2) Frame layers (hollow sides)
#############################
module "frame_layers" {
  for_each = {
    for lvl in local.frame_levels : tostring(lvl.idx) => lvl
  }

  source   = "../../frame" # your frame module path
  material = var.material

  # This is the bottom-left corner of the frame for this layer
  start_position = {
    x = each.value.x0
    y = each.value.y
    z = each.value.z0
  }

  # Square cross-section at this level (side_len × side_len)
  width  = each.value.side_len
  height = each.value.side_len

  # We just want a single "slice" (a ring for this layer),
  # so treat the frame as running "up" by 1.
  depth     = 1
  direction = "up"
}

#############################
# 3) Optional solid top cap
#############################
resource "minecraft_fill" "top_cap" {
  count    = var.top_cap ? 1 : 0
  material = var.material

  start = {
    x = local.top_cap_layer.x0
    y = local.top_cap_layer.y
    z = local.top_cap_layer.z0
  }

  end = {
    x = local.top_cap_layer.x0 + local.top_cap_layer.side_len - 1
    y = local.top_cap_layer.y
    z = local.top_cap_layer.z0 + local.top_cap_layer.side_len - 1
  }
}
