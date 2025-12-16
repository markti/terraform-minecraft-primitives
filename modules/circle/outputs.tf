locals {
  normal       = local.dir_to_delta[var.direction]
  start_center = local.center
  end_center = {
    x = local.center.x + local.normal.x
    y = local.center.y + local.normal.y
    z = local.center.z + local.normal.z
  }

  r = floor((var.diameter - 1) / 2)

  start_top    = { x = local.start_center.x + local.v_axis.x * local.r, y = local.start_center.y + local.v_axis.y * local.r, z = local.start_center.z + local.v_axis.z * local.r }
  start_bottom = { x = local.start_center.x - local.v_axis.x * local.r, y = local.start_center.y - local.v_axis.y * local.r, z = local.start_center.z - local.v_axis.z * local.r }
  start_left   = { x = local.start_center.x - local.u_axis.x * local.r, y = local.start_center.y - local.u_axis.y * local.r, z = local.start_center.z - local.u_axis.z * local.r }
  start_right  = { x = local.start_center.x + local.u_axis.x * local.r, y = local.start_center.y + local.u_axis.y * local.r, z = local.start_center.z + local.u_axis.z * local.r }
}

# Center of the start face (after transform)
output "start_center" {
  value = local.start_center
}

output "start_position" {
  value = {
    top    = local.start_top
    bottom = local.start_bottom
    left   = local.start_left
    right  = local.start_right
    center = local.start_center
    all = {
      top    = local.start_top,
      bottom = local.start_bottom,
      left   = local.start_left,
      right  = local.start_right,
      center = local.start_center
    }
  }
}
