module "transformed_start_position" {
  source = "../position"

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

  # Four cross-section corners (where our long sides start)
  c00 = local.start_position
  cW0 = { x = local.start_position.x + local.off_w.x, y = local.start_position.y + local.off_w.y, z = local.start_position.z + local.off_w.z }
  c0H = { x = local.start_position.x + local.off_h.x, y = local.start_position.y + local.off_h.y, z = local.start_position.z + local.off_h.z }
  cWH = { x = local.start_position.x + local.off_w.x + local.off_h.x, y = local.start_position.y + local.off_w.y + local.off_h.y, z = local.start_position.z + local.off_w.z + local.off_h.z }


  ##################################################################
  # Centers on the start face (square cross-section)
  ##################################################################

  # Half offsets (geometric midpoints)
  half_off_w = {
    x = local.off_w.x / 2.0
    y = local.off_w.y / 2.0
    z = local.off_w.z / 2.0
  }
  half_off_h = {
    x = local.off_h.x / 2.0
    y = local.off_h.y / 2.0
    z = local.off_h.z / 2.0
  }

  # Side centers on the start face
  center_bottom = { # between c00 and cW0
    x = local.c00.x + local.half_off_w.x
    y = local.c00.y + local.half_off_w.y
    z = local.c00.z + local.half_off_w.z
  }

  center_top = { # between c0H and cWH
    x = local.c0H.x + local.half_off_w.x
    y = local.c0H.y + local.half_off_w.y
    z = local.c0H.z + local.half_off_w.z
  }

  center_left = { # between c00 and c0H
    x = local.c00.x + local.half_off_h.x
    y = local.c00.y + local.half_off_h.y
    z = local.c00.z + local.half_off_h.z
  }

  center_right = { # between cW0 and cWH
    x = local.cW0.x + local.half_off_h.x
    y = local.cW0.y + local.half_off_h.y
    z = local.cW0.z + local.half_off_h.z
  }

  # Center-center of the square (midpoint of both axes)
  center_center = {
    x = local.start_position.x + local.half_off_w.x + local.half_off_h.x
    y = local.start_position.y + local.half_off_w.y + local.half_off_h.y
    z = local.start_position.z + local.half_off_w.z + local.half_off_h.z
  }
  # how far to move from start face to end face
  primary_offset = {
    x = (local.a.primary.axis == "x" ? local.a.primary.sign * (var.depth - 1) : 0)
    y = (local.a.primary.axis == "y" ? local.a.primary.sign * (var.depth - 1) : 0)
    z = (local.a.primary.axis == "z" ? local.a.primary.sign * (var.depth - 1) : 0)
  }

  # end face corners (start corners + primary extrusion)
  e00 = {
    x = local.c00.x + local.primary_offset.x
    y = local.c00.y + local.primary_offset.y
    z = local.c00.z + local.primary_offset.z
  }
  eW0 = {
    x = local.cW0.x + local.primary_offset.x
    y = local.cW0.y + local.primary_offset.y
    z = local.cW0.z + local.primary_offset.z
  }
  e0H = {
    x = local.c0H.x + local.primary_offset.x
    y = local.c0H.y + local.primary_offset.y
    z = local.c0H.z + local.primary_offset.z
  }
  eWH = {
    x = local.cWH.x + local.primary_offset.x
    y = local.cWH.y + local.primary_offset.y
    z = local.cWH.z + local.primary_offset.z
  }

  # end-face side centers
  end_center_bottom = {
    x = local.e00.x + local.half_off_w.x
    y = local.e00.y + local.half_off_w.y
    z = local.e00.z + local.half_off_w.z
  }
  end_center_top = {
    x = local.e0H.x + local.half_off_w.x
    y = local.e0H.y + local.half_off_w.y
    z = local.e0H.z + local.half_off_w.z
  }
  end_center_left = {
    x = local.e00.x + local.half_off_h.x
    y = local.e00.y + local.half_off_h.y
    z = local.e00.z + local.half_off_h.z
  }
  end_center_right = {
    x = local.eW0.x + local.half_off_h.x
    y = local.eW0.y + local.half_off_h.y
    z = local.eW0.z + local.half_off_h.z
  }

  # end center-center
  end_center_center = {
    x = local.e00.x + local.half_off_w.x + local.half_off_h.x
    y = local.e00.y + local.half_off_w.y + local.half_off_h.y
    z = local.e00.z + local.half_off_w.z + local.half_off_h.z
  }

  # ─────────────────────────────────────────────────────────────
  # MIDPOINT ALONG SHAFT
  # ─────────────────────────────────────────────────────────────

  # scalar mid distance from start (geometric midpoint)
  mid_t = (var.depth - 1) / 2.0

  mid_primary_offset = {
    x = (local.a.primary.axis == "x" ? local.a.primary.sign * local.mid_t : 0)
    y = (local.a.primary.axis == "y" ? local.a.primary.sign * local.mid_t : 0)
    z = (local.a.primary.axis == "z" ? local.a.primary.sign * local.mid_t : 0)
  }

  # mid-face corners (start corners + mid offset)
  m00 = {
    x = local.c00.x + local.mid_primary_offset.x
    y = local.c00.y + local.mid_primary_offset.y
    z = local.c00.z + local.mid_primary_offset.z
  }
  mW0 = {
    x = local.m00.x + local.off_w.x
    y = local.m00.y + local.off_w.y
    z = local.m00.z + local.off_w.z
  }
  m0H = {
    x = local.m00.x + local.off_h.x
    y = local.m00.y + local.off_h.y
    z = local.m00.z + local.off_h.z
  }
  mWH = {
    x = local.m00.x + local.off_w.x + local.off_h.x
    y = local.m00.y + local.off_w.y + local.off_h.y
    z = local.m00.z + local.off_w.z + local.off_h.z
  }

  # mid-face side centers
  mid_center_bottom = {
    x = local.m00.x + local.half_off_w.x
    y = local.m00.y + local.half_off_w.y
    z = local.m00.z + local.half_off_w.z
  }
  mid_center_top = {
    x = local.m0H.x + local.half_off_w.x
    y = local.m0H.y + local.half_off_w.y
    z = local.m0H.z + local.half_off_w.z
  }
  mid_center_left = {
    x = local.m00.x + local.half_off_h.x
    y = local.m00.y + local.half_off_h.y
    z = local.m00.z + local.half_off_h.z
  }
  mid_center_right = {
    x = local.mW0.x + local.half_off_h.x
    y = local.mW0.y + local.half_off_h.y
    z = local.mW0.z + local.half_off_h.z
  }

  # mid-face center-center
  mid_center_center = {
    x = local.m00.x + local.half_off_w.x + local.half_off_h.x
    y = local.m00.y + local.half_off_w.y + local.half_off_h.y
    z = local.m00.z + local.half_off_w.z + local.half_off_h.z
  }
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

# ── Top side (thickness = 1 on cy axis at +height-1) ────────────────────────
module "frame_top" {
  source         = "../cuboid"
  material       = var.material
  direction      = var.direction
  start_position = local.c0H # top edge: +height-1 along cy

  # Along shaft
  width = var.depth # along primary axis

  # Across the opening (cx axis)
  depth = var.width # full width of frame

  # Thickness of the top edge (1 block on cy axis)
  height = 1
}

# ── Bottom side (thickness = 1 on cy axis at base) ──────────────────────────
module "frame_bottom" {
  source         = "../cuboid"
  material       = var.material
  direction      = var.direction
  start_position = local.c00 # bottom edge

  width  = var.depth
  depth  = var.width
  height = 1
}

# ── Left side (thickness = 1 on cx axis at base) ────────────────────────────
module "frame_left" {
  source         = "../cuboid"
  material       = var.material
  direction      = var.direction
  start_position = local.c00 # left edge

  # Along shaft
  width = var.depth

  # Thickness on cx axis (1 block wide)
  depth = 1

  # Full vertical span on cy axis
  height = var.height
}

# ── Right side (thickness = 1 on cx axis at +width-1) ───────────────────────
module "frame_right" {
  source         = "../cuboid"
  material       = var.material
  direction      = var.direction
  start_position = local.cW0 # right edge: +width-1 along cx

  width  = var.depth
  depth  = 1
  height = var.height
}
