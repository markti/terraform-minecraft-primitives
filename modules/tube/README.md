# Tube Module

The **tube** module creates a hollow cylindrical ring in Minecraft, built from circle outlines extruded in a chosen direction.  
It is useful for tunnels, shafts, pipes, and other circular structures without manually calculating block coordinates.

---

## Inputs

| Name             | Type   | Description                                                                 | Constraints                  |
|------------------|--------|-----------------------------------------------------------------------------|------------------------------|
| `material`       | string | The block ID used for the tube (e.g., `"minecraft:stone"`).                  | Must be a valid Minecraft block ID |
| `start_position` | object | The **center coordinate** `{x,y,z}` of the circle’s starting face.           | North = -Z, South = +Z, East = +X, West = -X |
| `diameter`       | number | Circle diameter in blocks.                                                  | Integer ≥ 3 |
| `depth`          | number | Extrusion length of the tube along the given direction.                      | Integer ≥ 1 |
| `direction`      | string | The axis along which the tube is extruded. One of: `north`, `south`, `east`, `west`, `up`, `down`. | Must be valid |

---

## Behavior

- Generates a **circle outline** (ring) with the specified `diameter`.
- Extrudes the circle `depth` blocks along the chosen `direction`, producing a hollow tube.
- The circle lies in the two axes **perpendicular** to `direction`:
  - `north`/`south` → circle in X/Y plane, extruded along Z  
  - `east`/`west`   → circle in Z/Y plane, extruded along X  
  - `up`/`down`     → circle in X/Z plane, extruded along Y  

---

## Example Usage

### Horizontal Tube (North)

Creates a **9-block diameter stone tube**, running **10 blocks north** from the center point.

```hcl
module "tube_north" {
  source         = "markti/primitives/minecraft//modules/tube"
  material       = "minecraft:stone"
  start_position = { x = -30, y = 66, z = -230 } # circle center
  direction      = "north"
  diameter       = 9
  depth          = 10
}
