# Vector Module

The **vector** module creates a straight line of blocks in Minecraft using the `minecraft_fill` resource.  
It shields the user from calculating the end coordinates—just provide a starting position, a direction, a length, and the block material.

---

## Inputs

| Name            | Type   | Description                                                                 | Example                  |
|-----------------|--------|-----------------------------------------------------------------------------|--------------------------|
| `material`      | string | The block type to place (must be a valid Minecraft block ID).               | `"minecraft:stone"`      |
| `start_position`| object | Starting coordinate `{x, y, z}`. North = -Z, South = +Z, East = +X, West = -X. | `{ x = 0, y = 64, z = 0 }` |
| `length`        | number | Number of blocks to fill along the given direction (integer ≥ 1).           | `10`                     |
| `direction`     | string | Direction of placement. One of: `north`, `south`, `east`, `west`, `up`, `down`. | `"up"`                  |

---

## Behavior

- The **line** is inclusive: a length of `1` places exactly one block at `start_position`.  
- Positive directions:
  - **north** = −Z
  - **south** = +Z
  - **east**  = +X
  - **west**  = −X
  - **up**    = +Y
  - **down**  = −Y
- The end position is calculated automatically from the start, direction, and length.

---

## Example Usage

```hcl
locals {
  start_position = {
    x = -30
    y = 76
    z = -230
  }
}

module "up" {
  source         = "../../modules/vector"
  start_position = local.start_position
  material       = "minecraft:stone"
  direction      = "up"
  length         = 10
}
```