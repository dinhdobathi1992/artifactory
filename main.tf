

resource "artifactory_access_token" "admin" {
  username          = "jfrog_user"
  end_date_relative = "5m"
}

resource "artifactory_access_token" "admin3333" {
  username          = "jfrog_user"
  end_date_relative = "1m"
}
resource "time_rotating" "thoundsandmin" {
  rotation_minutes = 64000

}
resource "time_static" "thoundsandmin" {
  rfc3339 = time_rotating.thoundsandmin.rfc3339
}

resource "artifactory_access_token" "new_token" {
  username          = "jfrog_user"
  end_date = time_rotating.thoundsandmin.rotation_rfc3339

  lifecycle {
    replace_triggered_by = [
      time_static.rotate
    ]
  }

resource "aws_secretsmanager_secret_version" "new_token" {
  secret_id     = data.aws_secretsmanager_secret.example.id
  secret_string = artifactory_access_token.new_token.access_token
}
data "aws_secretsmanager_secret" "example" {
  name = "test_token"
}
data "aws_secretsmanager_secret_version" "by-version-stage" {
  secret_id     = data.aws_secretsmanager_secret.example.id
  #version_stage = "AWSCURRENT"
  depends_on = [ aws_secretsmanager_secret_version.new_token ]
}
output "test_token_creation_date" {
  value = substr("${data.aws_secretsmanager_secret_version.by-version-stage.created_date}", 0, 10)
  
}
