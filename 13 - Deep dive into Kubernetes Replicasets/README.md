
# 📝 Kubernetes Pods & ReplicaSet — Quick Revision Notes

---

## 1. What is a ReplicaSet (RS)?
- A **ReplicaSet** is a Kubernetes **controller**
- Its job: **Always keep N pods running**
- It continuously compares:
  - Desired state = `spec.replicas`
  - Current state = running pods
- If mismatch:
  - Create pods
  - Delete extra pods
  - Replace failed pods

> RS never runs pods itself — it only **ensures count**

---

## 2. Basic ReplicaSet YAML (Mind Map)

- `apiVersion: apps/v1`
- `kind: ReplicaSet`
- `metadata.name`
- `spec.replicas`
- `spec.selector`
- `spec.template` (this is the pod template)

Flow in head:
RS → stores Pod template → creates Pods from it

---

## 3. What Happens When You Apply YAML?

1. `kubectl apply` → sends request to **API Server**
2. API Server:
   - Authenticates
   - Authorizes
   - Validates
   - Stores object in **etcd**
3. ReplicaSet controller sees:
   - desired = 3, current = 0
   - → creates 3 Pod objects

---

## 4. Control Plane Flow (Super Important)

- **kubectl** → sends YAML
- **API Server** → brain, stores state in etcd
- **etcd** → database of cluster
- **ReplicaSet Controller** → checks pod count
- **Scheduler** → assigns node
- **Kubelet** → runs container on node
- **Container Runtime** → actually runs container

> Interview line: *"Kubernetes works on reconciliation loop"*

---

## 5. Pod Lifecycle Under ReplicaSet

- Pod created → Pending
- Scheduler assigns node → Scheduled
- Kubelet:
  - Pulls image
  - Creates container
  - Starts it
- Pod becomes → **Running**

---

## 6. Continuous Reconciliation Loop

ReplicaSet always does:
- List pods matching label
- Compare:
  - desired = 3
  - current = ?
- If equal → do nothing
- If not → fix it

---

## 7. Failure Scenarios (Favorite Exam Topic)

### Pod crashes:
- running = 2, desired = 3
- RS creates 1 new pod

### Node dies:
- Pods go to `Unknown`
- RS deletes them
- Creates new ones on healthy nodes

### You delete a pod manually:
- RS immediately creates a new one

### You delete ReplicaSet:
- All pods owned by it are deleted

---

## 8. How Kubernetes Stores This in etcd (Conceptual)

- `/registry/replicasets/.../nginx-rs`
- `/registry/pods/.../web-xxxxx`
- Each pod has:
  - `ownerReference` → ReplicaSet
  - `spec.nodeName`
  - `status: Running`

---

## 9. One-Line Summary

> ReplicaSet = **Controller that ensures correct number of pods are always running using reconciliation loop**

---

## 10. Tiny Memory Tricks

- RS = **Count Keeper**
- Scheduler = **Node Allotter**
- Kubelet = **Node Manager**
- etcd = **Cluster Memory**
- API Server = **Brain**


