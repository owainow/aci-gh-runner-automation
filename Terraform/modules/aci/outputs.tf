output userClientId {
  value = azurerm_container_group.self_hosted_runners.name
  description = "Container name"
}