output "vm_public_ip" {
  value       = azurerm_public_ip.dotstat_ip.ip_address
  description = "Public IP of the .Stat Suite VM"
}
