locals {
  existing_users = [
      "iasimov@${data.azuread_domains.default.domains.0.domain_name}",
      "lniven@${data.azuread_domains.default.domains.0.domain_name}",
      "fherbert@${data.azuread_domains.default.domains.0.domain_name}",
  ]
}

data "azuread_user" "user" {
  for_each = { for user in local.existing_users : user => user }
  user_principal_name = each.value
}

resource "azuread_group" "scifi" {
  display_name = "Science Fiction"
  security_enabled = true
}

resource "azuread_group_member" "member" {
  for_each = { for user in local.existing_users : user => user }
  group_object_id  = azuread_group.scifi.id
  member_object_id = data.azuread_user.user[each.key].id
} 