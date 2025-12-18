module "transformed_start_position" {
  source = "../position"

  start_position   = var.start_position
  translate_vector = var.transform
}

locals {
  center = module.transformed_start_position.result

  indices  = range(0, var.diameter)
  r        = var.diameter / 2
  center_i = floor((var.diameter - 1) / 2)

  # Only consider the TOP half: yi from center_i .. diameter-1
  y_indices_top = range(local.center_i, var.diameter)

  yz_candidates = flatten([
    for yi in local.y_indices_top : [
      for zi in local.indices : {
        yi = yi
        zi = zi
      }
    ]
  ])

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

  start_position = each.value.start_position
  transform = {
    x = 0
    y = 0
    z = 0
  }
}
