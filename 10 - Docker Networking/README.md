# Docker Networking — Personal Notes


## First, Some Core Networking Basics (My Reminder)

- IP address = unique address of a machine
- NIC = the physical network card (everything ultimately uses this)
- Switch = forwards frames using MAC table (inside LAN)
- ARP = maps IP → MAC
- Gateway = exit point of subnet
- NAT:
  - SNAT = change source IP (for internet access)
  - DNAT = change destination IP (for port forwarding)

---

## Why Docker Networking Exists

- Containers must:
  - Talk to each other
  - Talk to host
  - Talk to internet
- Docker uses:
  - Network namespaces
  - veth pairs
  - Linux bridges
  - iptables (NAT)

---

## Network Namespace (Very Important)

- Every container gets its own:
  - Network interface
  - Routing table
  - Firewall rules
- So each container thinks:
  “I have my own network stack”

---

## veth Pair (Virtual Cable)

- A veth pair is like a cable with two ends:
  - One end → inside container (eth0)
  - Other end → on host (vethxxx)
- This is how container connects to bridge.

---

## docker0 Bridge (Default Network)

- Docker creates:
  - docker0 bridge (like a virtual switch)
- Containers:
  - Get IP like 172.17.x.x
  - Can talk to each other
  - Can go to internet using NAT

My mental picture:
Container → veth → docker0 → host → internet

---

## How Container Reaches Internet (NAT)

- Docker adds iptables MASQUERADE rule
- Outgoing traffic:
  - Container IP → replaced with Host IP
- Reply comes back to host → forwarded to container

---

## Port Mapping (-p)

```bash
docker run -p 8080:80 nginx
```

Means:
Host:8080 → Container:80

Uses:
- DNAT
- iptables rules

---

## Types of Docker Networks (Must Remember)

1. bridge (default, most common)
2. host (no isolation, uses host network)
3. none (no networking at all)
4. overlay (multi-host)
5. macvlan (real MAC on LAN)

---

## 1. Bridge Network

- Default for Docker
- Containers can talk inside same network
- Custom bridge is better:

```bash
docker network create mynet
```

Benefits:
- Built-in DNS
- Better isolation

---

## 2. Host Network

```bash
docker run --network host nginx
```

- Container uses host network directly
- No isolation
- Very fast
- Rare, special use cases

---

## 3. None Network

```bash
docker run --network none alpine
```

- No networking
- Fully isolated
- Used for secure jobs

---

## 4. Overlay Network

- Used for multi-host containers
- Used in:
  - Docker Swarm
  - Kubernetes
- Uses VXLAN

---

## 5. Macvlan

- Each container gets:
  - Its own MAC
  - Appears like real machine on LAN
- Used when:
  - Need DHCP, broadcast, real network presence

---

## Inspecting Networks

```bash
docker network ls
docker network inspect bridge
docker inspect container_name
```

---

## Default Bridge vs Custom Bridge

Default bridge:
- No DNS discovery
- Must use IPs

Custom bridge:
- DNS works
- Containers can use names
- Cleaner setup

---

## Real World Pattern (App + DB)

- Create network
- Put app + db in same network
- App talks to DB using:
  db:3306

---

## My Final Mental Model

- Each container has:
  - Its own network namespace
- It connects using:
  - veth → bridge → host
- Internet access happens via:
  - NAT
- Most of the time:
  Just use custom bridge network

---

## One Line Summary

Docker networking is Linux networking + namespaces + bridges + NAT magic.