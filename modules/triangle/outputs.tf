locals {
  A = local.origin

  B = {
    x = local.origin.x + local.u.x * (var.width - 1)
    y = local.origin.y + local.u.y * (var.width - 1)
    z = local.origin.z + local.u.z * (var.width - 1)
  }

  C = {
    x = local.origin.x + local.v.x * (var.height - 1)
    y = local.origin.y + local.v.y * (var.height - 1)
    z = local.origin.z + local.v.z * (var.height - 1)
  }

  # Midpoints (integer block coords; uses floor so it always lands on a block)
  AB = {
    x = floor((local.A.x + local.B.x) / 2)
    y = floor((local.A.y + local.B.y) / 2)
    z = floor((local.A.z + local.B.z) / 2)
  }

  AC = {
    x = floor((local.A.x + local.C.x) / 2)
    y = floor((local.A.y + local.C.y) / 2)
    z = floor((local.A.z + local.C.z) / 2)
  }

  BC = {
    x = floor((local.B.x + local.C.x) / 2)
    y = floor((local.B.y + local.C.y) / 2)
    z = floor((local.B.z + local.C.z) / 2)
  }
}
output "points" {
  value = {
    A  = local.A
    B  = local.B
    C  = local.C
    AB = local.AB
    AC = local.AC
    BC = local.BC
    all = {
      A  = local.A
      B  = local.B
      C  = local.C
      AB = local.AB
      AC = local.AC
      BC = local.BC
    }
  }
}
