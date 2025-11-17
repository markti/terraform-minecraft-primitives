module "transformed_start_position" {
  source = "../position"

  start_position   = var.start_position
  translate_vector = var.transform
}

locals {
  start_position = module.transformed_start_position.result

  # For each direction, define:
  # - primary: axis/sign for WIDTH
  # - other1:  axis/sign for DEPTH
  # - other2:  axis/sign for HEIGHT
  #
  # Conventions:
  # - Horizontal directions: width on that axis, depth on the other horizontal (+), height on +Y.
  # - Vertical directions:   width on Y (±), depth on +X, height on +Z.
  dir_axes = {
    north = {
      primary = { axis = "z", sign = -1 } # width along -Z
      other1  = { axis = "x", sign = 1 }  # depth along +X
      other2  = { axis = "y", sign = 1 }  # height along +Y
    }
    south = {
      primary = { axis = "z", sign = 1 } # width along +Z
      other1  = { axis = "x", sign = 1 } # depth along +X
      other2  = { axis = "y", sign = 1 } # height along +Y
    }
    east = {
      primary = { axis = "x", sign = 1 } # width along +X
      other1  = { axis = "z", sign = 1 } # depth along +Z
      other2  = { axis = "y", sign = 1 } # height along +Y
    }
    west = {
      primary = { axis = "x", sign = -1 } # width along -X
      other1  = { axis = "z", sign = 1 }  # depth along +Z
      other2  = { axis = "y", sign = 1 }  # height along +Y
    }
    up = {
      primary = { axis = "y", sign = 1 } # width along +Y (your rule)
      other1  = { axis = "x", sign = 1 } # depth along +X
      other2  = { axis = "z", sign = 1 } # height along +Z
    }
    down = {
      primary = { axis = "y", sign = -1 } # width along -Y (your rule)
      other1  = { axis = "x", sign = 1 }  # depth along +X
      other2  = { axis = "z", sign = 1 }  # height along +Z
    }
  }

  axes = local.dir_axes[var.direction]

  # Inclusive math: end = start + delta*(size - 1)
  # Map sizes to axes based on above table.
  dx = (
    local.axes.primary.axis == "x" ? local.axes.primary.sign * (var.width - 1) :
    local.axes.other1.axis == "x" ? local.axes.other1.sign * (var.depth - 1) :
    local.axes.other2.axis == "x" ? local.axes.other2.sign * (var.height - 1) : 0
  )

  dy = (
    local.axes.primary.axis == "y" ? local.axes.primary.sign * (var.width - 1) :
    local.axes.other1.axis == "y" ? local.axes.other1.sign * (var.depth - 1) :
    local.axes.other2.axis == "y" ? local.axes.other2.sign * (var.height - 1) : 0
  )

  dz = (
    local.axes.primary.axis == "z" ? local.axes.primary.sign * (var.width - 1) :
    local.axes.other1.axis == "z" ? local.axes.other1.sign * (var.depth - 1) :
    local.axes.other2.axis == "z" ? local.axes.other2.sign * (var.height - 1) : 0
  )

  raw_end = {
    x = local.start_position.x + local.dx
    y = local.start_position.y + local.dy
    z = local.start_position.z + local.dz
  }

  # Normalize to keep providers happy
  start_corner = {
    x = min(local.start_position.x, local.raw_end.x)
    y = min(local.start_position.y, local.raw_end.y)
    z = min(local.start_position.z, local.raw_end.z)
  }
  end_corner = {
    x = max(local.start_position.x, local.raw_end.x)
    y = max(local.start_position.y, local.raw_end.y)
    z = max(local.start_position.z, local.raw_end.z)
  }
}

resource "minecraft_fill" "cuboid" {
  material = var.material

  start = {
    x = local.start_corner.x
    y = local.start_corner.y
    z = local.start_corner.z
  }

  end = {
    x = local.end_corner.x
    y = local.end_corner.y
    z = local.end_corner.z
  }
}
