# Kubernetes Networking — Personal Notes


## Big Picture

Kubernetes networking must solve:

1. Container-to-Container (inside Pod)
2. Pod-to-Pod (same node)
3. Pod-to-Pod (different nodes)
4. Pod-to-Service
5. Pod-to-Internet (egress)
6. Internet-to-Pod (ingress)

Design rules (Kubernetes model):

- All Pods can talk to all Pods WITHOUT NAT
- All Nodes can talk to all Pods WITHOUT NAT
- Pod IP is same inside and outside the pod

---

## 1. Container-to-Container (Inside a Pod)

- All containers in a Pod:
  - Share the same network namespace
  - Same IP
  - Same ports
  - Same loopback

So:

> Containers talk using localhost

My mental model:
> A Pod is one machine, containers are processes.

---

## 2. Pod-to-Pod (Same Node)

- Each Pod has:
  - Its own network namespace
- Each Pod connects using:
  - veth pair

Flow:

Pod eth0 → veth → Linux bridge → veth → other Pod eth0

- Bridge uses ARP to find destination Pod.

---

## 3. Pod-to-Pod (Different Nodes)

- Each node has a Pod CIDR range:
  - Node1: 10.0.1.0/24
  - Node2: 10.0.2.0/24

Flow:

1. Pod → veth → bridge
2. Bridge cannot ARP → sends to node eth0
3. Node routes packet to other node
4. Destination node → bridge → veth → target Pod

Who manages this routing?
> CNI plugin (Calico, Flannel, Weave, AWS VPC CNI)

---

## 4. Pod-to-Service (ClusterIP)

Problem:
- Pods are ephemeral
- IPs change
- Scale up/down

Solution:
> Service gives stable IP + DNS

How traffic is routed:

Two implementations:

### A) iptables

- kube-proxy writes iptables rules
- Traffic to ServiceIP:
  - DNAT to one Pod
- Return traffic:
  - SNAT back

### B) IPVS (modern)

- Kernel-level load balancer
- Faster
- Scales better

---

## 5. DNS (CoreDNS)

- Every Service gets DNS:

service.namespace.svc.cluster.local

- CoreDNS runs inside cluster
- Watches Services and Endpoints

So Pods use:

> http://backend-svc

Instead of IPs.

---

## 6. Pod-to-Internet (Egress)

Problem:
- Internet doesn’t know Pod IPs

Solution:
- Node does SNAT

Flow:

Pod IP → Node IP → Internet

---

## 7. Internet-to-Pod (Ingress)

Two ways:

### A) Service Type LoadBalancer (L4)

Internet → Cloud LB → NodePort → Service → Pod

Good for:
- Simple TCP/UDP

---

### B) Ingress Controller (L7)

Examples:
- NGINX Ingress
- AWS ALB
- Traefik
- Istio Gateway

Provides:
- Host based routing
- Path based routing
- SSL termination

Flow:

Internet → Ingress → Service → Pod

---

## How This Matches What We Saw in Class

Class concepts:

- Containers in same Pod use localhost
- Pods on same node use CNI virtual network
- Pods on different nodes use routing + iptables
- kube-proxy maintains service routing
- CoreDNS handles service name resolution
- Services abstract Pods and load balance traffic

---

## Commands to Observe Networking

```bash
kubectl get svc
kubectl describe svc <svc>
kubectl get endpoints
kubectl get pods -o wide
```

---

## My Final Mental Model

- Pod = mini machine
- veth = virtual cable
- bridge = virtual switch
- CNI = network engineer
- Service = virtual load balancer
- kube-proxy = traffic police
- CoreDNS = phonebook

---

## One Page Summary

Container-to-Container → localhost  
Pod-to-Pod (same node) → veth + bridge  
Pod-to-Pod (cross node) → routing via CNI  
Pod-to-Service → iptables/IPVS DNAT  
DNS → CoreDNS  
Egress → SNAT Pod → Node → Internet  
Ingress → LoadBalancer or Ingress Controller  

---

## One Line Summary

> Kubernetes networking is Linux networking + CNI + kube-proxy + CoreDNS working together to make the cluster look like one flat network.