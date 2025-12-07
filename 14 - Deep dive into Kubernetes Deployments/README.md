# Kubernetes Deployments — Quick Revision Notes

## 1. Big Picture

Pod:
- Smallest unit in Kubernetes
- Runs one or more containers
- Not self-healing
- If it dies, it is gone

ReplicaSet:
- Ensures a fixed number of pods are always running
- If a pod dies, it creates a new one
- Does not support rolling updates or rollback

Deployment:
- High-level controller used in real production
- Manages ReplicaSets
- Adds rolling updates, rollback, pause/resume, versioning
- This is what we should use to run stateless apps

---

## 2. Relationship

Deployment
 -> creates and owns ReplicaSet
    -> ReplicaSet creates and maintains Pods
       -> Pods run containers

---

## 3. Basic Deployment YAML Structure

- apiVersion: apps/v1
- kind: Deployment
- metadata.name
- spec.replicas
- spec.selector
- spec.template (this is the Pod template)

Deployment YAML looks almost same as ReplicaSet YAML. Only the kind changes.

---

## 4. What Happens When You Apply a Deployment

kubectl apply -f deployment.yaml

1. Request goes to API Server
2. API Server validates and stores object in etcd
3. Deployment controller wakes up
4. It creates or updates a ReplicaSet
5. ReplicaSet creates required number of Pods
6. Scheduler assigns Pods to nodes
7. Kubelet pulls image and starts containers

---

## 5. Internal Control Plane Flow

- kubectl: sends YAML
- API Server: validates and stores state
- etcd: stores everything
- Deployment Controller: manages ReplicaSets
- ReplicaSet Controller: manages Pods
- Scheduler: assigns nodes
- Kubelet: runs containers on node
- Container runtime: actually runs containers

---

## 6. How Self-Healing Works

Kubernetes runs a reconciliation loop:

- Desired state is stored in etcd
- Actual state comes from kubelets
- If mismatch is found, controller fixes it

Example:
- desired replicas = 3
- actual running = 2
- system immediately creates 1 new Pod

---

## 7. Rollout Strategies

Two strategies:

1. RollingUpdate (default)
- Gradually replace old pods with new ones
- Uses:
  - maxUnavailable
  - maxSurge
- Ensures near zero downtime

2. Recreate
- Deletes all old pods first
- Then creates new pods
- Used when two versions cannot run together

---

## 8. How Updates Work Internally

When you change image or spec:

1. New Pod template hash is generated
2. New ReplicaSet is created
3. New pods are created gradually
4. Old ReplicaSet is scaled down
5. Old ReplicaSet is kept for rollback

Each update creates a new revision.

---

## 9. Rollback Concept

- Deployment keeps history using ReplicaSets
- Each ReplicaSet has a revision number
- Rollback simply means:
  - Scale down current RS
  - Scale up old RS

Commands:
- kubectl rollout status deployment/app
- kubectl rollout history deployment/app
- kubectl rollout undo deployment/app

---

## 10. Pausing and Resuming Rollout

Pause:
kubectl rollout pause deployment/app

Make multiple changes.

Resume:
kubectl rollout resume deployment/app

Used for controlled releases and debugging.

---

## 11. Scaling a Deployment

kubectl scale deployment app --replicas=10

This:
- Updates Deployment spec in etcd
- ReplicaSet creates or deletes pods

---

## 12. How Data Is Stored in etcd (Conceptual)

- /registry/deployments/namespace/name
- /registry/replicasets/namespace/name
- /registry/pods/namespace/name

Deployment stores:
- spec
- strategy
- revision
- template
- status

ReplicaSet stores:
- desired replicas
- template hash
- owner reference to Deployment

Pod stores:
- spec
- nodeName
- status

---

## 13. Deleting a Deployment

kubectl delete deployment app

This:
- Deletes Deployment
- Deletes ReplicaSets
- Deletes Pods
- All entries removed from etcd

---

## 14. One Line Summary

Deployment is a high-level controller that manages ReplicaSets and Pods, provides rolling updates, rollback, scaling, and continuously maintains the desired state using the reconciliation loop.

---

## 15. Quick Exam / Interview Lines

- Pod is not self-healing, ReplicaSet and Deployment provide self-healing.
- Deployment is the recommended way to run stateless applications.
- Every update creates a new ReplicaSet.
- Rollback is just switching back to an old ReplicaSet.
- Kubernetes always works on desired state vs actual state.

