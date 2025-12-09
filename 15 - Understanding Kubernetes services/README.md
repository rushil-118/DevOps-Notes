# Kubernetes Core Concepts 


## What is Kubernetes?

- Kubernetes = container orchestration platform
- It manages:
  - Deploy
  - Scale
  - Heal
  - Network
  - Rollout / rollback
- Used to run applications across many machines (cluster)

---

## Core Building Blocks

- Pod → smallest unit
- ReplicaSet → keeps N pods alive
- Deployment → manages ReplicaSets
- Service → stable network access
- LoadBalancer → external traffic entry

---

## 1. Pod (Smallest Unit)

> Pod = one or more containers running together

- All containers in a pod:
  - Share IP
  - Share ports
  - Share volumes
- They are:
  - Co-located
  - Co-scheduled

My note:
> Pod is like a house, containers are rooms, IP is for the house.

---

## 2. ReplicaSet

> Ensures N copies of a Pod are always running

- If pod dies → new pod is created
- Even for 1 pod:
  Always use ReplicaSet or Deployment for safety
- Used internally by Deployments

---

## 3. Deployment

> Higher level controller for apps

- Uses ReplicaSets internally
- Supports:
  - Rolling updates
  - Rollbacks
  - Scaling
- This is what we use in real life, not raw pods.

---

## 4. Why We Need Services

Pods are:
- Ephemeral
- IP changes on restart
- Scale up/down

So:
> You should NEVER talk to pods directly.

---

## 5. What is a Service?

> A Service gives a stable IP + DNS name for a group of pods

Service provides:
- Stable virtual IP
- DNS name
- Load balancing
- Traffic routing via kube-proxy

---

## How Service Works (Internally)

1. You create service with selector:
   app: backend
2. kube-proxy programs iptables/ipvs
3. Service gets ClusterIP
4. Traffic to ClusterIP → forwarded to pods

---

## 6. Types of Services (Very Important)

### 1) ClusterIP (Default)

- Only inside cluster
- Used for:
  - Microservice to microservice
  - DB access
  - Internal backends

---

### 2) NodePort

- Exposes service on:
  NodeIP:NodePort (30000–32767)

Flow:
Internet → NodeIP:NodePort → Service → Pod

Used for:
- Local clusters
- Testing
- Bare metal

---

### 3) LoadBalancer (Cloud)

- Creates cloud LB (AWS, GCP, Azure)
- Flow:
Internet → Cloud LB → NodePort → Service → Pod

You get:
- Public IP

Used for:
> Production external traffic

---

## 7. Headless Service

- clusterIP: None
- Used for:
  - StatefulSets
  - Databases

---

## 8. Service DNS

Every service gets:

service.namespace.svc.cluster.local

---

## 9. YAML Structure

Every k8s object has:

apiVersion  
kind  
metadata  
spec  

---

## My Final Mental Model

- Pod = worker
- ReplicaSet = supervisor
- Deployment = manager
- Service = reception desk
- LoadBalancer = main gate

---

## One Line Summary

Kubernetes apps are deployed using Deployments, kept alive by ReplicaSets, and accessed through Services.