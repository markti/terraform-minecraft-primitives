module "transformed_start_position" {
  source = "../position"

  start_position   = var.start_position
  translate_vector = var.transform
}

locals {

  start_position = module.transformed_start_position.result

  axis_map = {
    north = { primary = "z", u = "x", v = "y" }
    south = { primary = "z", u = "x", v = "y" }
    east  = { primary = "x", u = "z", v = "y" }
    west  = { primary = "x", u = "z", v = "y" }
    up    = { primary = "y", u = "x", v = "z" }
    down  = { primary = "y", u = "x", v = "z" }
  }
  a = local.axis_map[var.direction]

  # circle selection using squared distances (no sqrt)
  r      = var.diameter / 2.0
  r2_min = (local.r - 0.5) * (local.r - 0.5)
  r2_max = (local.r + 0.5) * (local.r + 0.5)
  r_i    = floor(local.r)

  grid = flatten([
    for u in range(-local.r_i, local.r_i + 1) : [
      for v in range(-local.r_i, local.r_i + 1) : {
        u   = u
        v   = v
        dsq = u * u + v * v
      }
    ]
  ])

  perimeter_uv = [
    for p in local.grid : { u = p.u, v = p.v }
    if p.dsq >= local.r2_min && p.dsq <= local.r2_max
  ]

  # ✅ correct comprehension syntax + use local.a
  perimeter_xyz = [
    for p in local.perimeter_uv : {
      x = local.start_position.x + (local.a.u == "x" ? p.u : 0) + (local.a.v == "x" ? p.v : 0)
      y = local.start_position.y + (local.a.u == "y" ? p.u : 0) + (local.a.v == "y" ? p.v : 0)
      z = local.start_position.z + (local.a.u == "z" ? p.u : 0) + (local.a.v == "z" ? p.v : 0)
    }
  ]

  keyed_points = { for idx, p in local.perimeter_xyz : tostring(idx) => p }
}

# One vector per perimeter point, extruded along 'direction' by depth
module "ring_vectors" {
  source = "../vector"

  for_each = local.keyed_points

  material       = var.material
  direction      = var.direction
  start_position = each.value
  length         = var.depth
}
