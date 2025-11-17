

module "castle_turret1" {
  source = "../../modules/tube"

  start_position = module.volcano.base_position.corners.south_west
  transform = {
    x = 0
    y = 2
    z = 35
  }
  material  = "stone"
  direction = "up"
  diameter  = 10
  depth     = 12

}

module "south_wall" {
  source = "../../modules/frame"

  height = 8
  width  = 5
  length = 30

  start_position = module.castle_turret1.start_position.right
  transform = {
    x = 1
    y = 0
    z = -2
  }
  material  = "stone"
  direction = "east"
}

module "castle_turret2" {
  source = "../../modules/tube"

  start_position = module.south_wall.end_position.side_centers.bottom
  transform = {
    x = 5
    y = 0
    z = 0
  }
  material  = "stone"
  direction = "up"
  diameter  = 10
  depth     = 12

}

module "east_wall" {
  source = "../../modules/frame"

  height = 8
  width  = 5
  length = 30

  # Attach to the east side of turret2 and run north
  start_position = module.castle_turret2.start_position.top
  transform = {
    x = -2 # one block further out from the tower
    y = 0
    z = 1 # pull slightly north to line up visually
  }

  material  = "stone"
  direction = "south"
}

module "west_wall" {
  source = "../../modules/frame"

  height = 8
  width  = 5
  length = 30

  # Attach to the east side of turret2 and run north
  start_position = module.castle_turret1.start_position.top
  transform = {
    x = -2 # one block further out from the tower
    y = 0
    z = 1 # pull slightly north to line up visually
  }

  material  = "stone"
  direction = "south"
}

module "castle_turret3" {
  source = "../../modules/tube"

  # Centered at the far end of the east wall
  start_position = module.east_wall.end_position.side_centers.bottom
  transform = {
    x = 0 # shift outward from the wall by the tube radius
    y = 0
    z = 5
  }

  material  = "stone"
  direction = "up"
  diameter  = 10
  depth     = 14
}

module "castle_turret4" {
  source = "../../modules/tube"

  # Centered at the far end of the east wall
  start_position = module.west_wall.end_position.side_centers.bottom
  transform = {
    x = 0 # shift outward from the wall by the tube radius
    y = 0
    z = 5
  }

  material  = "stone"
  direction = "up"
  diameter  = 10
  depth     = 14
}


module "north_wall" {
  source = "../../modules/frame"

  height = 8
  width  = 5
  length = 30

  start_position = module.castle_turret4.start_position.right
  transform = {
    x = 1
    y = 0
    z = -2
  }
  material  = "stone"
  direction = "east"
}

locals {
  # Base of the south wall (same as its start_position after transform)
  south_wall_base = {
    x = module.castle_turret1.start_position.right.x + 1
    y = module.castle_turret1.start_position.right.y
    z = module.castle_turret1.start_position.right.z - 2
  }

  # Doorway size
  south_gate_width  = 3 # blocks along X (wall direction)
  south_gate_height = 4 # blocks up
  south_gate_depth  = 5 # how far we drill back (along Z)

  # Place the gate roughly centered along the 30-block wall:
  # wall runs east from base.x for length=30
  south_gate_offset_x = floor(30 / 2) # ≈ center
  south_gate_start = {
    x = local.south_wall_base.x + local.south_gate_offset_x - floor(local.south_gate_width / 2)
    y = local.south_wall_base.y + 1 # 1 block above ground
    z = local.south_wall_base.z     # front face of wall (south side)
  }
}

module "south_gate_hole" {
  source = "../../modules/cuboid"

  material  = "minecraft:air"
  direction = "east"

  start_position = local.south_gate_start

  width  = local.south_gate_width  # along east (X)
  height = local.south_gate_height # up (Y)
  depth  = local.south_gate_depth  # back (Z), clears wall thickness and a bit more
}
