resource "azuread_user" "bobhope" {
  display_name        = "Bob Hope"
  user_principal_name = "bobhope@${data.azuread_domains.default.domains.0.domain_name}"
}

resource "azuread_user" "jimmystewart" {
  display_name        = "Jimmy Stewart"
  user_principal_name = "jimmystewart@${data.azuread_domains.default.domains.0.domain_name}"
}

resource "azuread_user" "garycooper" {
  display_name        = "Gary Cooper"
  user_principal_name = "garycooper@${data.azuread_domains.default.domains.0.domain_name}"
}


resource "azuread_group" "famous_people" {
  display_name     = "Famous People"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [
    azuread_user.bobhope.object_id,
    azuread_user.jimmystewart.object_id,
    azuread_user.garycooper.object_id
    /* more users */
  ]
}

resource "azuread_group" "actors" {
  display_name     = "Actors"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [
    azuread_user.jimmystewart.object_id,
    azuread_user.garycooper.object_id
    /* more users */
  ]
}