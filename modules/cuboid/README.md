# Cuboid Module

The **cuboid** module creates a 3D rectangular block (a cuboid) in Minecraft using the `minecraft_fill` resource.  
It shields the user from having to calculate corner coordinates—just provide a starting position, a direction, and the desired dimensions.

---

## Inputs

| Name            | Type   | Description                                                                                       | Example                  |
|-----------------|--------|---------------------------------------------------------------------------------------------------|--------------------------|
| `material`      | string | The block type to place (must be a valid Minecraft block ID).                                      | `"minecraft:stone"`      |
| `start_position`| object | Starting coordinate `{x, y, z}`. North = -Z, South = +Z, East = +X, West = -X.                     | `{ x = 0, y = 64, z = 0 }` |
| `direction`     | string | The axis along which **width** is applied. One of: `north`, `south`, `east`, `west`, `up`, `down`. | `"up"`                  |
| `width`         | number | Blocks along the chosen direction (integer ≥ 1).                                                  | `10`                     |
| `depth`         | number | Blocks along the first perpendicular axis (integer ≥ 1).                                          | `2`                      |
| `height`        | number | Blocks along the second perpendicular axis (integer ≥ 1).                                         | `2`                      |

---

## Behavior

- **Width** extends along the chosen `direction`.  
  - Horizontal directions (north/south/east/west): width runs along X/Z.  
  - Vertical directions (up/down): width runs along Y.  
- **Depth** extends along one perpendicular axis:  
  - For horizontal directions, this is the other horizontal axis.  
  - For vertical directions, this is the +X axis.  
- **Height** extends along the remaining axis:  
  - For horizontal directions, this is always +Y (up).  
  - For vertical directions, this is the +Z axis.  
- The end position is calculated automatically as inclusive (size = N means N blocks).  
- Start and end corners are normalized so that `minecraft_fill` works in all directions.

---

## Example Usage

### Vertical pillar (Up)

```hcl
locals {
  start_position = {
    x = -30
    y = 68
    z = -230
  }
}

module "up" {
  source         = "../../modules/cuboid"
  start_position = local.start_position
  material       = "minecraft:stone"
  direction      = "up"
  width          = 10  # along Y
  depth          = 2   # along +X
  height         = 2   # along +Z
}
```