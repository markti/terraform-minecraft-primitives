# Minecraft Primitives Module Library

The **primitives** module library provides reusable Terraform modules for constructing basic Minecraft structures using the [`minecraft` provider](https://registry.terraform.io/providers/markti/minecraft/latest).  
It includes three building blocks:

- [`vector`](./modules/vector) – place a line of blocks in a given direction
- [`cuboid`](./modules/cuboid) – place a 3D rectangular block (cuboid)
- [`position`](./modules/position) – calculate translated coordinates for modular builds

These primitives can be combined to create larger, more complex structures (pillars, walls, towers, or even entire buildings) without needing to manually calculate block coordinates.

---

## Provider Configuration

Before using the modules, configure the `minecraft` provider.  
The provider connects to your Minecraft server via RCON.

```hcl
terraform {
  required_providers {
    minecraft = {
      source  = "markti/minecraft"
      version = "~> 0.0.22"
    }
  }
}

provider "minecraft" {
  address  = "${var.server_address}:${var.server_port}"
  password = var.rcon_password
}
```

## Example Usage

### Vector (Line / Pillar)

```hcl
module "pillar_up" {
  source         = "markti/primitives/minecraft//modules/vector"
  version        = "1.0.1"

  start_position = { x = 0, y = 64, z = 0 }
  material       = "minecraft:stone"
  direction      = "up"
  length         = 10
}
```

### Position (Coordinate Shifting)

```hcl
module "pos_east" {
  source           = "markti/primitives/minecraft//modules/position"
  version          = "1.0.1"

  start_position   = { x = 0, y = 64, z = 0 }
  translate_vector = { x = 5, y = 0, z = 0 }
}

# Use the shifted position in another module
module "cube_east" {
  source         = "markti/primitives/minecraft//modules/cuboid"
  version        = "1.0.1"

  start_position = module.pos_east.position
  material       = "minecraft:stone"
  direction      = "up"
  width          = 3
  depth          = 3
  height         = 3
}
```

### Cuboid (Block / Wall)

```hcl
module "wall_north" {
  source         = "markti/primitives/minecraft//modules/cuboid"
  version        = "1.0.1"

  start_position = { x = -10, y = 64, z = 0 }
  material       = "minecraft:oak_planks"
  direction      = "north"
  width          = 5   # along -Z
  depth          = 2   # along +X
  height         = 3   # along +Y
}
```
