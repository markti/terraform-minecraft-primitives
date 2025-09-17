# Position Module

The **position** module creates a new coordinate (`{x, y, z}`) by applying a translation vector to a given starting position.  
It’s a small utility module designed to make it easier to shift positions in Minecraft builds without recalculating coordinates manually.

---

## Inputs

| Name               | Type   | Description                                                                 | Example                           |
|--------------------|--------|-----------------------------------------------------------------------------|-----------------------------------|
| `start_position`   | object | The base coordinate `{x, y, z}`. North = -Z, South = +Z, East = +X, West = -X. | `{ x = 0, y = 64, z = 0 }`        |
| `translate_vector` | object | The offset `{x, y, z}` to add to the start position.                        | `{ x = 0, y = -1, z = 0 }`        |

---

## Outputs

| Name        | Type   | Description                       |
|-------------|--------|-----------------------------------|
| `position`  | object | The translated coordinate `{x,y,z}`.|

---

## Example Usage

### Create Vectors Next to each other

```hcl

locals {
  start_position = {
    x = -30
    y = 76
    z = -230
  }
}

# createa vector that goes upward
module "up" {
  source = "../../modules/vector"

  count = 1

  start_position = local.start_position
  material       = "stone"
  direction      = "up"
  length         = 10

}

# shift the start position down one block
module "down_start_position" {
  source         = "../../modules/position"
  start_position = local.start_position
  translate_vector = {
    x = 0
    y = -1
    z = 0
  }
}

# createa vector that goes downward
module "down" {
  source = "../../modules/vector"

  count = 1

  start_position = module.down_start_position.result
  material       = "stone"
  direction      = "down"
  length         = 10

}
```

### Move one block down
```hcl
module "down_start_position" {
  source           = "../../modules/position"
  start_position   = local.start_position
  translate_vector = {
    x = 0
    y = -1
    z = 0
  }
}
```

### Move one block north (−Z)
```hcl
module "north_start_position" {
  source           = "../../modules/position"
  start_position   = local.start_position
  translate_vector = {
    x = 0
    y = 0
    z = -1
  }
}
```

### Move one block south (+Z)
```hcl
module "south_start_position" {
  source           = "../../modules/position"
  start_position   = local.start_position
  translate_vector = {
    x = 0
    y = 0
    z = 1
  }
}
```

### Move one block east (+X)
```hcl
module "east_start_position" {
  source           = "../../modules/position"
  start_position   = local.start_position
  translate_vector = {
    x = 1
    y = 0
    z = 0
  }
}
```

### Move one block west (−X)
```hcl
module "west_start_position" {
  source           = "../../modules/position"
  start_position   = local.start_position
  translate_vector = {
    x = -1
    y = 0
    z = 0
  }
}
```