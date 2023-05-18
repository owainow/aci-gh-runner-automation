# Write output for azure container group main.tf
output userClientId {
  value = module.aci.self_hosted_runners.name
  description = "Container name"
}