resource "azuread_group" "development" {
  display_name = "Development Department"
  security_enabled = true
}

resource "azuread_group_member" "development_engineers" {
  for_each = { for u in azuread_user.users: u.mail_nickname => u if u.department == "Development" }

  group_object_id  = azuread_group.development.id
  member_object_id = each.value.id
}

resource "azuread_group" "managers" {
  display_name = "Development - Managers"
  security_enabled = true
}

resource "azuread_group_member" "managers" {
  for_each = { for u in azuread_user.users: u.mail_nickname => u if u.job_title == "Manager" }

  group_object_id  = azuread_group.managers.id
  member_object_id = each.value.id
}

resource "azuread_group" "engineers" {
  display_name = "Development - Engineers"
  security_enabled = true
}

resource "azuread_group_member" "engineers" {
  for_each = { for u in azuread_user.users: u.mail_nickname => u if u.job_title == "Engineer" }

  group_object_id  = azuread_group.engineers.id
  member_object_id = each.value.id
}

resource "azuread_group" "devops" {
  display_name = "Development - DevOps"
  security_enabled = true
}

resource "azuread_group_member" "devops_engineers" {
  for_each = { for u in azuread_user.users: u.mail_nickname => u if u.job_title == "DevOps"}

  group_object_id  = azuread_group.devops.id
  member_object_id = each.value.id
}

resource "azuread_group" "deploy" {
  display_name = "Development - Deploy"
  security_enabled = true
   members = [
    azuread_user.users["Sample1"].object_id,
    azuread_user.users["Sample3"].object_id,
    azuread_user.users["Sample4"].object_id
  ]
}
