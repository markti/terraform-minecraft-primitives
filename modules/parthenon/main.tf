############################################
# Base: Ziggurat
############################################

module "base" {
  source = "../ziggurat"

  material = var.ziggurat.material
  width    = var.ziggurat.width
  height   = var.ziggurat.height
  length   = var.ziggurat.length

  start_position = var.start_position
}

############################################
# Derived geometry
############################################

locals {
  # "Top" of the ziggurat:
  #
  # We’ll assume each ziggurat step raises Y by 1, and shrinks the footprint.
  # If your ziggurat algorithm differs, we can adjust this math to match it exactly.
  top_y = var.start_position.y + var.ziggurat.height

  # Shrink per step: 2 blocks per step (one per side) is the common pattern.
  # If yours shrinks differently, change shrink_per_step.
  shrink_per_step = 2

  top_length = var.ziggurat.length - (var.ziggurat.height * local.shrink_per_step)
  top_width  = var.ziggurat.width - (var.ziggurat.height * local.shrink_per_step)

  # top "origin" (north-west corner) moved inward by height steps
  top_origin = {
    x = var.start_position.x + var.ziggurat.height
    y = local.top_y
    z = var.start_position.z + var.ziggurat.height
  }

  # Temple footprint (defaults: fit inside top surface with margin)
  temple_length = var.temple.length != null ? var.temple.length : max(local.top_length - 2, 1)
  temple_width  = var.temple.width != null ? var.temple.width : max(local.top_width - 2, 1)

  # Center temple on the top surface
  temple_origin = {
    x = local.top_origin.x + floor((local.top_length - local.temple_length) / 2)
    y = local.top_origin.y
    z = local.top_origin.z + floor((local.top_width - local.temple_width) / 2)
  }

  # Column ring inset (so columns sit on the stylobate, not hanging off edges)
  col_inset = var.temple.column_inset

  # Column base Y (on stylobate)
  col_base_y = local.temple_origin.y + 1
}

############################################
# Stylobate / floor (a platform)
############################################

module "stylobate" {
  source = "../ziggurat"

  start_position = local.temple_origin
  length         = local.temple_length
  width          = local.temple_width
  height         = var.temple.stylobate_height

  material = var.temple.materials.stylobate
}

############################################
# Columns
############################################

# Helper locals for perimeter column positions.
# We place columns along all four edges, with configurable spacing.
locals {
  # Column grid along X edges (length)
  x_positions = [
    for x in range(0, local.temple_length) :
    x if(x % var.temple.column_spacing == 0) || (x == local.temple_length - 1)
  ]

  # Column grid along Z edges (width)
  z_positions = [
    for z in range(0, local.temple_width) :
    z if(z % var.temple.column_spacing == 0) || (z == local.temple_width - 1)
  ]

  # Build a set of perimeter points (dedupe corners automatically via key)
  columns = merge(
    # North edge (z = inset)
    {
      for x in local.x_positions :
      "N_${x}" => {
        x = local.temple_origin.x + x
        y = local.col_base_y
        z = local.temple_origin.z + local.col_inset
      }
    },
    # South edge (z = width-1-inset)
    {
      for x in local.x_positions :
      "S_${x}" => {
        x = local.temple_origin.x + x
        y = local.col_base_y
        z = local.temple_origin.z + (local.temple_width - 1 - local.col_inset)
      }
    },
    # West edge (x = inset)
    {
      for z in local.z_positions :
      "W_${z}" => {
        x = local.temple_origin.x + local.col_inset
        y = local.col_base_y
        z = local.temple_origin.z + z
      }
    },
    # East edge (x = length-1-inset)
    {
      for z in local.z_positions :
      "E_${z}" => {
        x = local.temple_origin.x + (local.temple_length - 1 - local.col_inset)
        y = local.col_base_y
        z = local.temple_origin.z + z
      }
    }
  )
}

module "columns" {
  for_each = local.columns
  source   = "../vector"

  material       = var.temple.materials.columns
  start_position = each.value
  direction      = "up"
  length         = var.temple.column_height
  transform = {
    x = 0
    y = 0
    z = 0
  }
}

############################################
# Entablature (top beam ring)
############################################

# A simple beam ring one block above the column tops.
locals {
  beam_y = local.col_base_y + var.temple.column_height
  beam_origin = {
    x = local.temple_origin.x + local.col_inset
    y = local.beam_y
    z = local.temple_origin.z + local.col_inset
  }
  beam_length = local.temple_length - (2 * local.col_inset)
  beam_width  = local.temple_width - (2 * local.col_inset)
}

module "entablature" {
  source = "../ziggurat"

  start_position = local.beam_origin
  length         = local.beam_length
  width          = local.beam_width
  height         = var.temple.entablature_height

  material = var.temple.materials.entablature
}

############################################
# Roof (simple pitched look using triangles)
############################################
/*
# Two pediments (east/west faces) using your triangle module.
# You can refine this later into a proper pitched roof; this gives a strong “temple” vibe fast.
locals {
  roof_base_y = local.beam_y + var.temple.entablature_height

  # West face (yz plane), start at west edge of beam ring
  roof_west_start = {
    x = local.beam_origin.x
    y = local.roof_base_y
    z = local.beam_origin.z
  }

  # East face (yz plane), start at east edge of beam ring
  roof_east_start = {
    x = local.beam_origin.x + (local.beam_length - 1)
    y = local.roof_base_y
    z = local.beam_origin.z
  }
}

module "roof_west_pediment" {
  source = "../triangle"

  material  = var.temple.materials.roof
  direction = "east"
  plane     = "yz"
  height    = var.temple.roof_height
  width     = local.beam_width

  start_position = local.roof_west_start
  transform = {
    x = 0
    y = 0
    z = 0
  }
}

module "roof_east_pediment" {
  source = "../triangle"

  material  = var.temple.materials.roof
  direction = "west"
  plane     = "yz"
  height    = var.temple.roof_height
  width     = local.beam_width

  start_position = local.roof_east_start
  transform = {
    x = 0
    y = 0
    z = 0
  }
}
*/
