resource "aws_db_subnet_group" "sonarqube-db" {
  name       = "sq-2022"
  subnet_ids = module.vpc.private_subnets
  # subnet_ids = [aws_subnet.frontend.id, aws_subnet.backend.id]
  #subnet_ids = tolist(module.vpc.private_subnets) # .aws_subnet.private.*.id]
  #, module.vpc.aws_subnet.private.[1]]
  tags = {
    Name = "My SonarQube db subnet group"
  }
}

output "private_subnets" {
  value = module.vpc.private_subnets
}


# terraform import aws_rds_cluster.sonar-postgres  sonarqube-database-1
resource "aws_rds_cluster" "sonar-postgres-test" {
  db_subnet_group_name = aws_db_subnet_group.sonarqube-db.name
  cluster_identifier   = "sonarqube-db-202201"
  engine               = "aurora-postgresql"
  engine_mode          = "serverless"
  deletion_protection  = true
  scaling_configuration {
    min_capacity             = 2
    max_capacity             = 384
    auto_pause               = false
    seconds_until_auto_pause = 300
  }

  #    "${aws_security_group.sec-sonarqube-db.id}"
  #        "${aws_security_group.sec-sonarqube-db.id}"
  vpc_security_group_ids = [
    aws_security_group.sec-sonarqube-db-2022-sg.id
  ]
  copy_tags_to_snapshot = true
  enable_http_endpoint  = true
  skip_final_snapshot   = true
  master_username       = "postgres"
  master_password       = var.sq_db_master_password
  # master_password     = "redhorse123"  # I think this is the actual master password, but including it here triggers a change.
  # database_name       = "sonar"  # forces replacement; for now we are provisioning the database manually
  database_name           = "sonar"
  backup_retention_period = 7
  # lifecycle {
  #   prevent_destroy = true
  # }
}

output "rds_master_username" {
  value = aws_rds_cluster.sonar-postgres-test.master_username
}

output "db_endpoint" {
  value = aws_rds_cluster.sonar-postgres-test.endpoint
}

# I don't think we are actually using AWS secrets manager in our infrastructure, although the artifacts exist.
# resource "aws_secretsmanager_secret_version" "SecretsManagerSecretVersion" {
#   # secret_id     = "arn:aws:secretsmanager:us-east-1:506504484053:secret:sonarqube/aurora-postgres-KdVNi4"
#   secret_string = "{\"username\":\"sonar\",\"password\":\"sonar_password\",\"engine\":\"postgres\",\"host\":\"sonarqube-database-1.cluster-ced4z8ivlyxo.us-east-1.rds.amazonaws.com\",\"port\":5432,\"dbClusterIdentifier\":\"sonarqube-database-1\"}"
#   # tags          = var.resource_tags
# }
