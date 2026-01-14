# AWS + Terraform


## Big Picture

> This class focused on **building AWS infrastructure using Terraform** and understanding how networking, state, and dependencies work together.

---

## 1. VPC Basics

### What is a VPC?

- VPC = Virtual Private Cloud
- It is your **own private network inside AWS**
- You define:
  - IP range (CIDR)
  - Subnets
  - Routing
  - Internet access

---

## 2. CIDR Block

> CIDR defines how big your network is.

Example:

```text
10.0.0.0/16
```

Means:
- Large private network range
- You split this into subnets

---

## 3. Subnets

> Subnet = smaller network inside VPC

### Types:

### Public Subnet
- Has route to Internet Gateway
- Can access internet
- Used for:
  - Load balancers
  - Bastion hosts
  - Public servers

### Private Subnet
- NO direct internet access
- Used for:
  - Databases
  - Backend services

---

## 4. Route Tables

> Route tables decide **where traffic goes**

Example:

- 0.0.0.0/0 → Internet Gateway = public subnet
- No IGW route = private subnet

---

## 5. Types of IP Addresses in AWS

### Private IP
- Used inside VPC only
- Not reachable from internet

### Public IP
- Reachable from internet
- Changes if instance restarts

### Elastic IP
- Static public IP
- Can be reattached to other instances

---

## 6. EC2 and AMI

> You CANNOT create EC2 without AMI.

- AMI = OS image (Ubuntu, Amazon Linux, etc)
- AMI is the base for EC2

---

## 7. Terraform State File

> terraform.tfstate = memory of Terraform

- Stores:
  - What exists in cloud
  - What Terraform created
- Used for:
  - Change detection
  - Dependency tracking

---

## 8. Remote State (Team Work)

> When many people work together:

- Store state in:
  - S3
- Lock using:
  - DynamoDB

Benefits:
- No state conflicts
- Safe collaboration

---

## 9. Terraform File Structure (Common Practice)

- main.tf → main logic
- network.tf → VPC, subnets, IGW
- compute.tf → EC2, security groups
- variables.tf → inputs
- outputs.tf → outputs

---

## 10. Terraform Dependencies

> Terraform figures out order automatically.

This is called:
> Implicit dependency

Example:
- Subnet uses VPC ID → Terraform creates VPC first

---

## 11. Variables in Terraform

### Input Variables
- Make code reusable

### Output Variables
- Show useful values after apply

### Local Variables
- Used inside file only

---

## 12. My Mental Model

- VPC = your data center
- Subnet = your rack
- Route table = traffic police
- Terraform = infra factory
- tfstate = memory

---

## One Line Summary

> This class teaches how to design AWS networking and infrastructure using Terraform with proper state management, variables, and dependency handling.