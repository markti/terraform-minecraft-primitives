variable "server_address" {
  type = string
}
variable "server_port" {
  type    = string
  default = 25575
}
variable "rcon_password" {
  type      = string
  sensitive = true
}
