# Kubernetes — Personal Revision Notes

---

## What is Kubernetes?

- Kubernetes (K8s) = container orchestration platform
- Think of it as:
  OS for your data center
- It handles:
  - Deploy
  - Scale
  - Heal
  - Network
  - Storage
  - Rolling updates
- Main idea:
  You declare what you want, Kubernetes keeps fixing things to match it.

---

## Big Picture Architecture

- Two parts:
  - Control Plane = Brain
  - Worker Nodes = Muscles

---

## Control Plane (Brain)

### kube-apiserver

- All kubectl commands go here
- Validates requests
- Talks to etcd
- Stateless

Note:
If API server is down, cluster is uncontrollable.

---

### etcd

- Key-value store
- Stores cluster state, config, secrets
- If etcd is lost → cluster is basically lost

Note:
etcd backup is critical.

---

### kube-scheduler

- Decides where pods run
- Checks CPU, RAM, node health, rules

---

### kube-controller-manager

- Keeps checking:
  Desired state vs Actual state
- If mismatch → fixes it

---

### cloud-controller-manager

- Only in cloud
- Creates LB, disks, routes

---

## Worker Nodes

### kubelet

- Runs on every node
- Makes sure pods actually run
- Pulls images, restarts containers

My note:
kubelet = hands of Kubernetes

---

### kube-proxy

- Handles service networking
- Does load balancing

---

### Container Runtime

- Kubernetes uses:
  - containerd
  - CRI-O
- Runtime starts containers

---

## CNI (Networking)

- Gives IP to each pod
- Examples: Calico, Flannel, Cilium

---

## CSI (Storage)

- Handles persistent volumes

---

## What Happens When I Apply YAML

1. kubectl → API server
2. API server → etcd
3. Scheduler picks node
4. kubelet creates container
5. kube-proxy updates rules
6. Controller keeps checking replicas

---

## My Mental Model

- Brain = control plane
- Memory = etcd
- Hands = kubelet
- Traffic police = kube-proxy
- Decision maker = scheduler
- Auto-fixer = controllers

---

## One Line Summary

Kubernetes is a system that constantly makes reality match what you declared.
