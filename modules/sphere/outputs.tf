output "center" {
  value = local.center
}

output "diameter" {
  value = var.diameter
}

output "scanline_count" {
  value = length(keys(local.row_spans))
}
