locals {
  # ... your existing locals (dir_axes, axes, dx/dy/dz, raw_end, start_corner, end_corner) ...

  # Convenience aliases for bounds
  min_x = local.start_corner.x
  max_x = local.end_corner.x
  min_y = local.start_corner.y
  max_y = local.end_corner.y
  min_z = local.start_corner.z
  max_z = local.end_corner.z

  mid_x = floor((local.min_x + local.max_x) / 2)
  mid_y = floor((local.min_y + local.max_y) / 2)
  mid_z = floor((local.min_z + local.max_z) / 2)

  # ... min_x/max_x/mid_x etc already defined ...

  ############################
  # Bottom horizontal edges (y = min_y)
  ############################

  edge_bottom_north = {
    start = {
      x = local.min_x
      y = local.min_y
      z = local.min_z
    }
    end = {
      x = local.max_x
      y = local.min_y
      z = local.min_z
    }
    center = {
      x = local.mid_x
      y = local.min_y
      z = local.min_z
    }
  }

  edge_bottom_south = {
    start = {
      x = local.min_x
      y = local.min_y
      z = local.max_z
    }
    end = {
      x = local.max_x
      y = local.min_y
      z = local.max_z
    }
    center = {
      x = local.mid_x
      y = local.min_y
      z = local.max_z
    }
  }

  edge_bottom_west = {
    start = {
      x = local.min_x
      y = local.min_y
      z = local.min_z
    }
    end = {
      x = local.min_x
      y = local.min_y
      z = local.max_z
    }
    center = {
      x = local.min_x
      y = local.min_y
      z = local.mid_z
    }
  }

  edge_bottom_east = {
    start = {
      x = local.max_x
      y = local.min_y
      z = local.min_z
    }
    end = {
      x = local.max_x
      y = local.min_y
      z = local.max_z
    }
    center = {
      x = local.max_x
      y = local.min_y
      z = local.mid_z
    }
  }

  ############################
  # Top horizontal edges (y = max_y)
  ############################

  edge_top_north = {
    start = {
      x = local.min_x
      y = local.max_y
      z = local.min_z
    }
    end = {
      x = local.max_x
      y = local.max_y
      z = local.min_z
    }
    center = {
      x = local.mid_x
      y = local.max_y
      z = local.min_z
    }
  }

  edge_top_south = {
    start = {
      x = local.min_x
      y = local.max_y
      z = local.max_z
    }
    end = {
      x = local.max_x
      y = local.max_y
      z = local.max_z
    }
    center = {
      x = local.mid_x
      y = local.max_y
      z = local.max_z
    }
  }

  edge_top_west = {
    start = {
      x = local.min_x
      y = local.max_y
      z = local.min_z
    }
    end = {
      x = local.min_x
      y = local.max_y
      z = local.max_z
    }
    center = {
      x = local.min_x
      y = local.max_y
      z = local.mid_z
    }
  }

  edge_top_east = {
    start = {
      x = local.max_x
      y = local.max_y
      z = local.min_z
    }
    end = {
      x = local.max_x
      y = local.max_y
      z = local.max_z
    }
    center = {
      x = local.max_x
      y = local.max_y
      z = local.mid_z
    }
  }

  ############################
  # Vertical edges (columns)
  ############################

  edge_vertical_north_west = {
    start = {
      x = local.min_x
      y = local.min_y
      z = local.min_z
    }
    end = {
      x = local.min_x
      y = local.max_y
      z = local.min_z
    }
    center = {
      x = local.min_x
      y = local.mid_y
      z = local.min_z
    }
  }

  edge_vertical_north_east = {
    start = {
      x = local.max_x
      y = local.min_y
      z = local.min_z
    }
    end = {
      x = local.max_x
      y = local.max_y
      z = local.min_z
    }
    center = {
      x = local.max_x
      y = local.mid_y
      z = local.min_z
    }
  }

  edge_vertical_south_west = {
    start = {
      x = local.min_x
      y = local.min_y
      z = local.max_z
    }
    end = {
      x = local.min_x
      y = local.max_y
      z = local.max_z
    }
    center = {
      x = local.min_x
      y = local.mid_y
      z = local.max_z
    }
  }

  edge_vertical_south_east = {
    start = {
      x = local.max_x
      y = local.min_y
      z = local.max_z
    }
    end = {
      x = local.max_x
      y = local.max_y
      z = local.max_z
    }
    center = {
      x = local.max_x
      y = local.mid_y
      z = local.max_z
    }
  }

  # Aggregate for a nice output
  edges_all = {
    bottom_north = local.edge_bottom_north
    bottom_south = local.edge_bottom_south
    bottom_west  = local.edge_bottom_west
    bottom_east  = local.edge_bottom_east

    top_north = local.edge_top_north
    top_south = local.edge_top_south
    top_west  = local.edge_top_west
    top_east  = local.edge_top_east

    vertical_north_west = local.edge_vertical_north_west
    vertical_north_east = local.edge_vertical_north_east
    vertical_south_west = local.edge_vertical_south_west
    vertical_south_east = local.edge_vertical_south_east
  }
}
