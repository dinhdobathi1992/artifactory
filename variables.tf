variable "github_repo_name_from_artifactory" {
  type = string
  description = "github repo name"
  default = "test"
}
variable "jfrog_access_token" {
  type = string
  description = "jfrog"
  sensitive = true
  default = ""
}