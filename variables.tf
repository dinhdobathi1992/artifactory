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

variable "AWS_ACCESS_KEY_ID" {
  type = string
  description = "AWS_ACCESS_KEY_ID" 
}

variable "AWS_SECRET_ACCESS_KEY" {
  type = string
  description = "AWS_SECRET_ACCESS_KEY"  
}