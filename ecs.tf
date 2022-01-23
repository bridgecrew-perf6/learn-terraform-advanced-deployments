resource "aws_ecs_cluster" "advanced-cluster" {
  name = "advanced-cluster" # Naming the cluster
}

resource "aws_ecs_task_definition" "advanced-task" {
  family                   = "advanced-task" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "advanced-task",
      "image": "${aws_ecr_repository.advanced-ecr-repo.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_ecs_service" "advanced-service" {
  name            = "advanced-service"                        # Naming our first service
  cluster         = aws_ecs_cluster.advanced-cluster.id             # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.advanced-task.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 1 # Setting the number of containers

  load_balancer {
    target_group_arn = aws_lb_target_group.java-app.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.advanced-task.family
    container_port   = 8080 # Specifying the container port
  }

  network_configuration {
    # subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    subnets        = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]] #count.index % length(module.vpc.public_subnets)]
    # subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}"]
    assign_public_ip = true # Providing our containers with public IPs
    # security_groups  = ["${aws_security_group.service_security_group.id}"]
    security_groups  = [module.lb_security_group.this_security_group_id]
  }
}

resource "aws_lb_target_group" "java-app" {
  name     = "java-app-${random_pet.app.id}-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}



