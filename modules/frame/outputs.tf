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
    left = {
      top    = local.c0H,
      center = local.center_left,
      bottom = local.c00,
    }
    right = {
      top    = local.cWH,
      center = local.center_right
      bottom = local.cW0,
    }
    all = {
      top          = local.center_top,
      center       = local.center_center,
      bottom       = local.center_bottom,
      bottom_left  = local.c00,
      bottom_right = local.cW0,
      top_left     = local.c0H,
      top_right    = local.cWH,
      left         = local.center_left
      right        = local.center_right
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
    left = {
      start_bottom_left = local.c00,
      start_top_left    = local.c0H,
      start_center_left = local.center_left
      top               = local.m0H,
      center            = local.mid_center_left,
      bottom            = local.m00,
      end_bottom_left   = local.e00,
      end_top_left      = local.e0H,
      end_center_left   = local.end_center_left,
    }
    right = {
      start_bottom_right = local.cW0,
      start_top_right    = local.cWH,
      start_center_right = local.center_right
      top                = local.mWH,
      center             = local.mid_center_right,
      bottom             = local.mW0,
      end_bottom_right   = local.eW0,
      end_top_right      = local.eWH,
      end_center_right   = local.end_center_right
    }
    all = {
      top    = local.mid_center_top,
      center = local.mid_center_center,
      bottom = local.mid_center_bottom,
    }
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
    left = {
      top    = local.e0H,
      center = local.end_center_left,
      bottom = local.e00,
    }
    right = {
      top    = local.eWH,
      center = local.end_center_right
      bottom = local.eW0,
    }
    all = {
      top          = local.end_center_top,
      center       = local.end_center_center,
      bottom       = local.end_center_bottom,
      bottom_left  = local.e00,
      bottom_right = local.eW0,
      top_left     = local.e0H,
      top_right    = local.eWH,
      center_left  = local.end_center_left,
      center_right = local.end_center_right
    }
  }
}
