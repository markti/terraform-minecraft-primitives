# Map which physical axes are the cross-section for each direction.
# - primary = axis the frame runs along (length = depth)
# - cx = first perpendicular axis used by width
# - cy = second perpendicular axis used by height
# Signs are chosen so increasing width/height goes outward in + direction.
locals {
  axis_map = {
    north = { primary = { axis = "z", sign = -1 }, cx = { axis = "x", sign = 1 }, cy = { axis = "y", sign = 1 } }
    south = { primary = { axis = "z", sign = 1 }, cx = { axis = "x", sign = 1 }, cy = { axis = "y", sign = 1 } }
    east  = { primary = { axis = "x", sign = 1 }, cx = { axis = "z", sign = 1 }, cy = { axis = "y", sign = 1 } }
    west  = { primary = { axis = "x", sign = -1 }, cx = { axis = "z", sign = 1 }, cy = { axis = "y", sign = 1 } }
    up    = { primary = { axis = "y", sign = 1 }, cx = { axis = "x", sign = 1 }, cy = { axis = "z", sign = 1 } }
    down  = { primary = { axis = "y", sign = -1 }, cx = { axis = "x", sign = 1 }, cy = { axis = "z", sign = 1 } }
  }

  a = local.axis_map[var.direction]

  # Offsets to the far edge of the cross-section (inclusive math → size-1)
  off_w = {
    x = (local.a.cx.axis == "x" ? local.a.cx.sign * (var.width - 1) : 0)
    y = (local.a.cx.axis == "y" ? local.a.cx.sign * (var.width - 1) : 0)
    z = (local.a.cx.axis == "z" ? local.a.cx.sign * (var.width - 1) : 0)
  }
  off_h = {
    x = (local.a.cy.axis == "x" ? local.a.cy.sign * (var.height - 1) : 0)
    y = (local.a.cy.axis == "y" ? local.a.cy.sign * (var.height - 1) : 0)
    z = (local.a.cy.axis == "z" ? local.a.cy.sign * (var.height - 1) : 0)
  }

  base = var.start_position

  # Four cross-section corners (where our long sides start)
  c00 = local.base
  cW0 = { x = local.base.x + local.off_w.x, y = local.base.y + local.off_w.y, z = local.base.z + local.off_w.z }
  c0H = { x = local.base.x + local.off_h.x, y = local.base.y + local.off_h.y, z = local.base.z + local.off_h.z }
  cWH = { x = local.base.x + local.off_w.x + local.off_h.x, y = local.base.y + local.off_w.y + local.off_h.y, z = local.base.z + local.off_w.z + local.off_h.z }
}

# Each side is a thin CUBOID running along 'direction' for length = depth.

# Helper: given a cross-section thickness on cx/cy, what cuboid args do we pass?
# For horizontals (N/S/E/W), the cuboid’s:
#   width  (Z or X along direction) = var.depth
#   depth  (other horizontal)       = either var.width or 1
#   height (Y)                      = either var.height or 1
# For verticals (UP/DOWN), the cuboid’s:
#   width (Y along direction) = var.depth
#   depth (X)                 = either var.width or 1
#   height (Z)                = either var.height or 1

# ── Top side (thickness = 1 on cy axis) ─────────────────────────────────────
module "frame_top" {
  source         = "../cuboid"
  material       = var.material
  direction      = var.direction
  start_position = local.c0H # at +height-1 on cy

  # map sizes into cuboid's (width, depth, height) per direction
  height = 1
  width  = var.width
  depth  = contains(["north", "south"], var.direction) ? var.width : contains(["east", "west"], var.direction) ? var.width : var.width
}

# ── Bottom side (thickness = 1 on cy axis at base) ──────────────────────────
module "frame_bottom" {
  source         = "../cuboid"
  material       = var.material
  direction      = var.direction
  start_position = local.c00

  height = 1
  width  = var.width
  depth  = contains(["north", "south"], var.direction) ? var.width : contains(["east", "west"], var.direction) ? var.width : var.width
}

# ── Left side (thickness = 1 on cx axis at base) ────────────────────────────
module "frame_left" {
  source         = "../cuboid"
  material       = var.material
  direction      = var.direction
  start_position = local.c00

  width  = var.width
  depth  = 1
  height = var.height
}

# ── Right side (thickness = 1 on cx axis at +width-1) ───────────────────────
module "frame_right" {
  source         = "../cuboid"
  material       = var.material
  direction      = var.direction
  start_position = local.cW0

  width  = var.width
  depth  = 1
  height = var.height
}
