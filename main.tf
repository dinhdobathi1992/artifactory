

resource "artifactory_access_token" "admin" {
  username          = "jfrog_user"
  end_date_relative = "5m"
}

resource "artifactory_access_token" "admin3333" {
  username          = "jfrog_user"
  end_date_relative = "1m"
}
resource "time_rotating" "thoundsandmin" {
  rotation_days = 365
  lifecycle {
    replace_triggered_by = [
      time_rotating.rotate_date.id
    ]
  }
}

resource "time_rotating" "rotate_date" {
  rotation_days = 275
}

#
resource "time_rotating" "tenmin" {
  rotation_minutes =  10
  triggers  = {
    "key"   = time_rotating.fiveminmin.rotation_rfc3339
  }
}

resource "time_rotating" "fiveminmin" {
  rotation_minutes =  5
}



resource "artifactory_access_token" "new_token_rotate" {
  username          = "jfrog_user"
  end_date = time_rotating.expired_date_min.rotation_rfc3339

  triggers  = {
    "key"   = time_rotating.fiveminmin.rotation_rfc3339
  }
}


#

resource "time_static" "thoundsandmin" {
  rfc3339 = time_rotating.thoundsandmin.rfc3339
}

resource "artifactory_access_token" "new_token" {
  username          = "jfrog_user"
  end_date = time_rotating.thoundsandmin.rotation_rfc3339

  lifecycle {
    replace_triggered_by = [
      time_rotating.rotate_date
    ]
  }
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


output "token_expired_date" {
  value = formatdate("YYYY-MM-DD", time_rotating.thoundsandmin.rotation_rfc3339)
}
output "valid_until" {
  value = "${formatdate("YYYY-MM-DD", timeadd(time_rotating.thoundsandmin.rotation_rfc3339, "-2160h"))}"
  
}

output "token_rotate_date" {
  value = formatdate("YYYY-MM-DD", time_rotating.rotate_date.rotation_rfc3339)
}

output "token_rotate_date_min" {
  value = time_rotating.rotate_date_min.rotation_rfc3339
}

output "expired_date_min" {
  value = time_rotating.expired_date_min.rotation_rfc3339
}



