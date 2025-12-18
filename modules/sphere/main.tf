module "transformed_start_position" {
  source = "../position"

  start_position   = var.start_position
  translate_vector = var.transform
}

locals {
  center = module.transformed_start_position.result

  # 0..diameter-1
  indices = range(0, var.diameter)

  # Sphere math uses cell-centers (Minecraft-style)
  r = var.diameter / 2

  # Center index of the discrete diameter grid
  center_i = floor((var.diameter - 1) / 2)

  # All (y,z) pairs in the diameter grid
  yz_candidates = flatten([
    for yi in local.indices : [
      for zi in local.indices : {
        yi = yi
        zi = zi
      }
    ]
  ])

  # For each (y,z), determine the contiguous X span that lies inside the sphere.
  #
  # We test voxel cell-centers:
  # (x+0.5 - r)^2 + (y+0.5 - r)^2 + (z+0.5 - r)^2 <= r^2
  #
  # Then we reduce the included X set to a single [min..max] span,
  # which we draw using your vector module (minecraft_fill).
  rows = {
    for yz in local.yz_candidates :
    "${yz.yi},${yz.zi}" => {
      yi = yz.yi
      zi = yz.zi

      xs = [
        for xi in local.indices : xi
        if(
          pow((xi + 0.5) - local.r, 2) +
          pow((yz.yi + 0.5) - local.r, 2) +
          pow((yz.zi + 0.5) - local.r, 2)
        ) <= pow(local.r, 2)
      ]
    }
    # keep only rows with at least one included x
    if length([
      for xi in local.indices : xi
      if(
        pow((xi + 0.5) - local.r, 2) +
        pow((yz.yi + 0.5) - local.r, 2) +
        pow((yz.zi + 0.5) - local.r, 2)
      ) <= pow(local.r, 2)
    ]) > 0
  }

  row_spans = {
    for k, row in local.rows :
    k => {
      yi     = row.yi
      zi     = row.zi
      x_min  = min(row.xs...)
      x_max  = max(row.xs...)
      length = max(row.xs...) - min(row.xs...) + 1

      # World-space start for this scanline:
      # x starts at x_min, y/ z are fixed for the row.
      start_position = {
        x = local.center.x + (min(row.xs...) - local.center_i)
        y = local.center.y + (row.yi - local.center_i)
        z = local.center.z + (row.zi - local.center_i)
      }
    }
  }
}

module "scanline" {
  source   = "../vector"
  for_each = local.row_spans

  material  = var.material
  direction = "east"
  length    = each.value.length

  # Already transformed/absolute
  start_position = each.value.start_position
  transform = {
    x = 0
    y = 0
    z = 0
  }
}
