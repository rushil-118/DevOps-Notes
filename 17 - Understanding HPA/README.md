# Kubernetes HPA —  Revision Notes

## What is HPA?

> HPA = Horizontal Pod Autoscaler

- Automatically:
  - Increases pods when load increases
  - Decreases pods when load drops
- Works on:
  - Deployment
  - ReplicaSet
  - StatefulSet
- Most common metric:
  - CPU

My one-liner:
> More load? Add more pods. Less load? Remove pods.

---

## Horizontal vs Vertical (My Memory Trick)

- Horizontal = add/remove PODS
- Vertical = increase/decrease CPU/RAM of SAME pod

HPA = Horizontal only.

---

## How HPA Works (Flow)

User traffic → Service → Pods  
Pods CPU ↑  
↓  
Metrics Server reports usage  
↓  
HPA Controller checks:  
> CPU usage / CPU request  
↓  
If > threshold → increase replicas  
If < threshold → decrease replicas  

---

## VERY IMPORTANT FORMULA

> HPA uses: CPU Usage / CPU Request

So:

- If requests.cpu is NOT set → HPA will NOT work

---

## Prerequisites (Must Have)

- Working cluster (kubeadm / any)
- Metrics Server (MANDATORY)

Check:

```bash
kubectl top nodes
kubectl top pods
```

If this works → metrics server is OK.

---

## Step-by-Step Setup (Exam Flow)

### 1) Install Metrics Server

Without this:
- HPA shows CPU = 0%
- No scaling happens

---

### 2) Create Deployment

Important:
- Must set:

```yaml
resources:
  requests:
    cpu: 200m
```

No request = No HPA.

---

### 3) Create Service

- Needed to:
  - Send traffic to pods
  - Generate load

---

### 4) Create HPA Object

Example logic:

- Min pods: 1
- Max pods: 10
- Target CPU: 50%

Meaning:

> If avg CPU > 50% → add pods

---

## HPA YAML (Mental Structure)

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
spec:
  scaleTargetRef: Deployment
  minReplicas: 1
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50
```

---

## How To Test HPA

Generate load using busybox:

```bash
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://my-service; done"
```

Watch scaling:

```bash
kubectl get hpa -w
kubectl get deploy
```

---

## What Happens Internally

1. CPU crosses 50%
2. Metrics Server reports it
3. HPA controller calculates desired replicas
4. Deployment scales
5. New pods are created

---

## Scale Down Behavior

- Not immediate
- Has cooldown period
- Gradual reduction

My note:
> Kubernetes is careful while removing pods.

---

## Common Problems (Very Common in Lab)

| Problem | Cause | Fix |
|--------|--------|------|
| CPU = 0% | No metrics server | Install metrics server |
| No scaling | No cpu request | Add requests.cpu |
| HPA not working | Label mismatch | Fix selector |

---

## Important Commands

```bash
kubectl get hpa
kubectl describe hpa
kubectl top pods
kubectl top nodes
kubectl get deploy
kubectl get events
```

---

## Interview Answer (Ready-Made)

> HPA monitors pod metrics via Metrics Server and automatically scales the number of replicas based on CPU or custom metrics thresholds defined in the HPA resource.

---

## My Final Mental Model

- Metrics Server = thermometer
- HPA = decision maker
- Deployment = executor
- Pods = workers

---

## One Line Summary

> HPA automatically adds or removes pods based on CPU load using metrics from Metrics Server.