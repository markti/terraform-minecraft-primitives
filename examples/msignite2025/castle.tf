locals {
  #castle_material      = "cobblestone"
  #turret_roof_material = "dark_oak_planks"

  #castle_material      = "stone_bricks"
  #turret_roof_material = "spruce_planks"

  #castle_material      = "polished_andesite"
  #turret_roof_material = "spruce_planks"

  castle_material      = "deepslate_bricks"
  turret_roof_material = "mangrove_planks"

  turret_diameter = 10
}

module "castle_turret1" {
  source = "../../modules/tube"

  start_position = module.volcano.base_position.corners.south_west
  transform = {
    x = 0
    y = 2
    z = 35
  }
  material  = local.castle_material
  direction = "up"
  diameter  = local.turret_diameter
  depth     = 12

}

module "south_wall" {
  source = "../../modules/frame"

  height = 8
  width  = 5
  depth  = 30

  start_position = module.castle_turret1.start_position.right
  transform = {
    x = 1
    y = 0
    z = -2
  }
  material  = local.castle_material
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
  material  = local.castle_material
  direction = "up"
  diameter  = local.turret_diameter
  depth     = 12

}

module "east_wall" {
  source = "../../modules/frame"

  height = 8
  width  = 5
  depth  = 30

  # Attach to the east side of turret2 and run north
  start_position = module.castle_turret2.start_position.top
  transform = {
    x = -2 # one block further out from the tower
    y = 0
    z = 1 # pull slightly north to line up visually
  }

  material  = local.castle_material
  direction = "south"
}

module "west_wall" {
  source = "../../modules/frame"

  height = 8
  width  = 5
  depth  = 30

  # Attach to the east side of turret2 and run north
  start_position = module.castle_turret1.start_position.top
  transform = {
    x = -2 # one block further out from the tower
    y = 0
    z = 1 # pull slightly north to line up visually
  }

  material  = local.castle_material
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

  material  = local.castle_material
  direction = "up"
  diameter  = local.turret_diameter
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

  material  = local.castle_material
  direction = "up"
  diameter  = local.turret_diameter
  depth     = 14
}


module "north_wall" {
  source = "../../modules/frame"

  height = 8
  width  = 5
  depth  = 30

  start_position = module.castle_turret4.start_position.right
  transform = {
    x = 1
    y = 0
    z = -2
  }
  material  = local.castle_material
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
/*
module "south_gate_hole" {
  source = "../../modules/cuboid"

  material  = "minecraft:air"
  direction = "east"

  start_position = local.south_gate_start

  width  = local.south_gate_width  # along east (X)
  height = local.south_gate_height # up (Y)
  depth  = local.south_gate_depth  # back (Z), clears wall thickness and a bit more

  depends_on = [module.south_wall]
}
*/
locals {
  turret_roof_length = local.turret_diameter + 2 # slightly larger than 10-wide turret
  turret_roof_half   = floor((local.turret_roof_length - 1) / 2)
}

module "castle_turret1_roof" {
  source = "../../modules/pyramid/hollow"

  material = local.turret_roof_material
  length   = local.turret_roof_length
  top_cap  = true

  # Center the pyramid over the turret top
  start_position = module.castle_turret1.end_center

  transform = {
    x = -local.turret_roof_half
    y = 1 # same Y as turret top; change to 1 if you want it to float one block up
    z = -local.turret_roof_half
  }
}

module "castle_turret2_roof" {
  source = "../../modules/pyramid/hollow"

  material = local.turret_roof_material
  length   = local.turret_roof_length
  top_cap  = true

  # Center the pyramid over the turret top
  start_position = module.castle_turret2.end_center

  transform = {
    x = -local.turret_roof_half
    y = 1 # same Y as turret top; change to 1 if you want it to float one block up
    z = -local.turret_roof_half
  }
}

module "castle_turret3_roof" {
  source = "../../modules/pyramid/hollow"

  material = local.turret_roof_material
  length   = local.turret_roof_length
  top_cap  = true

  # Center the pyramid over the turret top
  start_position = module.castle_turret3.end_center

  transform = {
    x = -local.turret_roof_half
    y = 1 # same Y as turret top; change to 1 if you want it to float one block up
    z = -local.turret_roof_half
  }
}


module "castle_turret4_roof" {
  source = "../../modules/pyramid/hollow"

  material = local.turret_roof_material
  length   = local.turret_roof_length
  top_cap  = true

  # Center the pyramid over the turret top
  start_position = module.castle_turret4.end_center

  transform = {
    x = -local.turret_roof_half
    y = 1 # same Y as turret top; change to 1 if you want it to float one block up
    z = -local.turret_roof_half
  }
}
