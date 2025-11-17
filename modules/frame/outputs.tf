output "start_position" {
  value = {
    center = local.center_center

    corners = {
      bottom_left  = local.c00
      bottom_right = local.cW0
      top_left     = local.c0H
      top_right    = local.cWH
    }

    side_centers = {
      bottom = local.center_bottom
      top    = local.center_top
      left   = local.center_left
      right  = local.center_right
    }
  }
}

output "mid_position" {
  value = {
    center = local.mid_center_center

    corners = {
      bottom_left  = local.m00
      bottom_right = local.mW0
      top_left     = local.m0H
      top_right    = local.mWH
    }

    side_centers = {
      bottom = local.mid_center_bottom
      top    = local.mid_center_top
      left   = local.mid_center_left
      right  = local.mid_center_right
    }
    all = [
      local.mid_center_center,
      local.m00,
      local.mW0,
      local.m0H,
      local.mWH,
      local.mid_center_bottom,
      local.mid_center_top,
      local.mid_center_left,
      local.mid_center_right
    ]
  }
}

output "end_position" {
  value = {
    center = local.end_center_center

    corners = {
      bottom_left  = local.e00
      bottom_right = local.eW0
      top_left     = local.e0H
      top_right    = local.eWH
    }

    side_centers = {
      bottom = local.end_center_bottom
      top    = local.end_center_top
      left   = local.end_center_left
      right  = local.end_center_right
    }
    all = {
      center       = local.end_center_center,
      bottom_left  = local.e00,
      bottom_right = local.eW0,
      top_left     = local.e0H,
      top_right    = local.eWH,
      bottom       = local.end_center_bottom,
      top          = local.end_center_top,
      left         = local.end_center_left,
      right        = local.end_center_right
    }
  }
}
