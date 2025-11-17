# Frame Module

The **frame** module creates a hollow rectangular frame (tube) in Minecraft using the [`minecraft_fill` resource](https://registry.terraform.io/providers/markti/minecraft/latest).  
It uses the `direction` input to determine which axis the frame extends along, and builds four thin sides to form a rectangular tunnel-like structure.

---

## Inputs

| Name             | Type   | Description                                                                                  | Constraints                  |
|------------------|--------|----------------------------------------------------------------------------------------------|------------------------------|
| `material`       | string | Block ID for the frame (e.g., `"minecraft:stone"`, `"minecraft:oak_planks"`).                 | Must be a valid Minecraft block ID |
| `start_position` | object | The base coordinate `{x,y,z}` where the frame starts.                                        | North = -Z, South = +Z, East = +X, West = -X |
| `width`          | number | Blocks along the cross-section width axis.                                                   | Integer ≥ 1 |
| `depth`          | number | Blocks along the primary direction axis.                                                     | Integer ≥ 1 |
| `height`         | number | Blocks along the cross-section height axis.                                                  | Integer ≥ 1 |
| `direction`      | string | The axis the frame extends along. One of: `north`, `south`, `east`, `west`, `up`, `down`.    | Must be valid |

---

## Axis Mapping

The meaning of `width`, `depth`, and `height` depends on the chosen `direction`:

- **North / South (Z-axis)**
  - `depth` = length along Z (−Z for north, +Z for south)
  - `width` = cross-section size along X
  - `height` = cross-section size along Y

- **East / West (X-axis)**
  - `depth` = length along X (+X for east, −X for west)
  - `width` = cross-section size along Z
  - `height` = cross-section size along Y

- **Up / Down (Y-axis)**
  - `depth` = length along Y (+Y for up, −Y for down)
  - `width` = cross-section size along X
  - `height` = cross-section size along Z

---

## Behavior

- The module places **four thin cuboids** to form the sides of the rectangular frame.
- The inside remains hollow, creating a tunnel or tube-like structure.
- Useful for building arches, tunnels, windows, and 3D frames without manual block calculations.

---

## Examples

### Horizontal Square-Frame (Tunnel)

Creates a **5×5 frame** that runs **10 blocks north**.

```hcl
module "tunnel" {
  source         = "../../modules/square-frame"

  material       = "minecraft:stone"
  start_position = { 
    x = -30, 
    y = 66, 
    z = -230 
  }
  direction      = "north"
  width          = 5
  height         = 5
  depth          = 10
}
```
