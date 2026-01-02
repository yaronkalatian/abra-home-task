# abra-home-task

# Overview
    This repository contains Terraform modules to provision a secure, scalable AWS web architecture. 
    The deployed application is a containerized “Hello World” running on ECS Fargate, 
    exposed publicly through API Gateway and internally routed via an Application Load Balancer (ALB).

# Diagram
    User
    ↓
    API Gateway (HTTP API)
    ↓
    VPC Link
    ↓
    Internal Application Load Balancer (Private Subnets)
    ↓
    ECS Fargate Tasks (Multi-AZ)


                        ┌──────────────────────┐
                        │   API Gateway (HTTP)  │
                        └─────────┬────────────┘
                                │ VPC Link
                                ▼
                    ┌──────────────────────────────┐
                    │ Internal ALB (Private Subnets)│
                    └─────────┬────────────┬────────┘
                            │            │
                ┌────────────▼───┐   ┌────▼───────────┐
                │ ECS Task (AZ-A) │   │ ECS Task (AZ-B)│
                │ Fargate         │   │ Fargate        │
                └────────────────┘   └────────────────┘

    Public Subnets:
    - NAT Gateway
    - IGW

    Private Subnets:
    - ALB
    - ECS Tasks

# project structure

    .
    ├── README.md
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── providers.tf
    ├── modules/
    │   ├── network/
    │   ├── ecs/
    │   ├── alb/
    │   └── api-gateway/


# Deployment Instructions
    1. Clone repo:
    git clone https://github.com/yaronkalatian/abra-home-task.git
    cd abra-home-task

    2. Initialize Terraform:
    terraform init

	3. Plan the deployment:
    terraform plan -out=tfplan
    
    4. Apply the plan:
    terraform apply tfplan

    5. Destroy resources after review to avoid cost:
    terraform destroy


# final results
<img width="1194" height="566" alt="image" src="https://github.com/user-attachments/assets/62cc156b-0032-48b2-bce7-c9af3bd69809" />






# Design Choices
	•	Internal ALB ensures zero public exposure of ECS
	•	API Gateway provides managed entry point + throttling
	•	Fargate removes EC2 management overhead
	•	Modular Terraform improves reusability and review clarity

# Scaling for Production
	•	Enable ECS Service Auto Scaling (CPU/ALB request count)
	•	Add WAF to API Gateway
	•	Use HTTPS with ACM
	•	Add VPC Endpoints (ECR, CloudWatch) to reduce NAT costs
	•	Enable ALB access logs
	•	Blue/Green deployments via CodeDeploy

# Resiliency
	•	Multi-AZ subnets
	•	Stateless containers
	•	Managed AWS services with auto-recovery
