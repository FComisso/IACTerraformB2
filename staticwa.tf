
resource "azurerm_static_web_app" "test" {
  name                = "${var.prefix}-static-site"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.rg.name
}

locals  {
  api_token_var = "AZURE_STATIC_WEB_APPS_API_TOKEN"
}



/* 
variable "github_token" {}
variable "github_owner" {}

provider "github" {
  token = var.github_token
  owner = var.github_owner
} */
/* 
resource "github_actions_secret" "test" {
  repository       = "my-first-static-app"
  secret_name      = local.api_token_var
  plaintext_value  = azurerm_static_site.test.api_key
}

# This will cause github provider crash, until https://github.com/integrations/terraform-provider-github/pull/732 is merged.
resource "github_repository_file" "foo" {
  repository          = "my-first-static-web-app"
  branch              = "main"
  file                = ".github/workflows/azure-static-web-app.yml"
  content             = templatefile("./azure-static-web-app.tpl",
    {
      app_location = "/"
      api_location = "api"
      output_location = ""
      api_token_var = local.api_token_var
    }
  )
  commit_message      = "Add workflow (by Terraform)"
  commit_author       = "magodo"
  commit_email        = "wztdyl@sina.com"
  overwrite_on_create = true
} */