variable "cust_domain" {
  description = "Customer domain (example. cust.services.sabio.co.uk)"
  type        = string
  default     = "testing.lab"
}

variable "cust_shortname"{
  description = "customer shortname"
  type        = string
  default     = "testing"
}

variable "cust_safemodepass"{
  description = "Domain safe mode password"
  type        = string
  default     = "SabioPass20190522!"
}

variable "cust_ip"{
  description = "Domain safe mode password"
  type        = string
  default     = "10.203.99.2"
}