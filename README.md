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
 	•	VPC with public + private subnets across 2 AZs
        Public subnets host NAT Gateways (and the IGW route), while private subnets host the internal 
        ALB and ECS Fargate tasks. This isolates the application from direct internet exposure 
        and provides high availability.
	•	API Gateway (HTTP API) + VPC Link to an internal ALB
        API Gateway is the only public entry point. It forwards requests via VPC Link to 
        a private/internal ALB, enabling a secure “front door” pattern without exposing
        the load balancer publicly.
	•	ECS Fargate with 2 tasks minimum
        Fargate removes EC2 management and runs tasks across multiple AZs.
         A desired count of 2 tasks provides basic resiliency if one AZ/task fails.
	•	Least-privilege Security Groups
	•	ALB SG allows inbound only from the VPC Link SG (port 80).
	•	ECS SG allows inbound only from the ALB SG (port 80).
	•	ECS tasks keep outbound access for image pulls/logging (via NAT or endpoints).
	•	Modular Terraform
        Separate modules for network, alb, ecs, and api-gateway keep the code reusable, testable,
        and easy to review. Inputs/outputs are passed explicitly to avoid hidden dependencies.
   

# Scaling for Production
	Autoscaling
	•	Enable ECS Service Auto Scaling based on CPU/memory and/or ALB request count.
	•	Use target-tracking policies and scale-in protections to avoid thrashing.

	Observability
	•	Centralize logs in CloudWatch Logs (ECS task logs + API Gateway access logs + ALB access 
        logs to S3).
	•	Add CloudWatch alarms (5XX rates, latency, unhealthy hosts, task count) and notifications
        via SNS/PagerDuty.

	Security hardening
	•	Add TLS (HTTPS) on API Gateway (and optionally ALB) with ACM certificates.
	•	Use AWS WAF on API Gateway for common protections (rate limiting, OWASP rules).
	•	Replace NAT dependency with VPC endpoints (ECR API/DKR, CloudWatch Logs, SSM) to 
        reduce attack surface and cost.

	Resiliency
	•	Keep everything multi-AZ and consider cross-zone load balancing.
	•	For higher availability, expand to 3 AZs and run more tasks.
	•	Use deployment strategies (rolling/blue-green via CodeDeploy) for safer releases.

	Networking & cost optimization
	•	Use VPC endpoints to reduce NAT Gateway traffic and costs.
	•	Consider a single NAT per AZ (current) vs. single NAT overall (cheaper but less resilient),
        depending on requirements.

	CI/CD & governance
	•	Add a pipeline (GitHub Actions) to run terraform fmt, validate, tflint, and plan.
	•	Use separate workspaces/accounts for dev/stage/prod and enforce tagging, IAM boundaries,
        and least privilege.

