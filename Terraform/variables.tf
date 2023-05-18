variable "location" {
  type    = string
  default = "EastUs"
}

variable "rg_name" {
  type    = string
  default = "rg-aci-ghrunners"
}

variable "vnet_name" {
  type = string
  default = "test-vnet"
  
}

variable gh_pat {
    default = ""
}

variable gh_repo_url {
    default = ""
}
