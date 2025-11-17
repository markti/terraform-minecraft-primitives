# Center of the start face (after transform)
output "start_center" {
  value = local.start_position
}

output "start_position" {
  value = {
    top    = local.start_top
    bottom = local.start_bottom
    left   = local.start_left
    right  = local.start_right
    center = local.start_position
    all = {
      top    = local.start_top,
      bottom = local.start_bottom,
      left   = local.start_left,
      right  = local.start_right,
      center = local.start_position
    }
  }
}

# Center of the far end face — ideal for chaining the next tube
output "end_center" {
  value = local.end_center
}

# End face extents for connecting / decorating
output "end_position" {
  value = {
    top    = local.end_top
    bottom = local.end_bottom
    left   = local.end_left
    right  = local.end_right
    center = local.end_center
    all = {
      top    = local.end_top,
      bottom = local.end_bottom,
      left   = local.end_left,
      right  = local.end_right,
      center = local.end_center
    }
  }
}
