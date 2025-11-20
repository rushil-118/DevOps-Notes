# Docker Volumes — Personal Notes

---

## Why Do We Even Need Volumes?

- Containers are ephemeral
- They have:
  - Read-only image
  - One writable layer
- When container is removed:
  - Writable layer is deleted
  - All data is lost
- So:
  If data must survive container → use Volumes or Bind Mounts

Examples of data that would be lost:
- /var/lib/mysql
- /usr/share/nginx/html
- /app/logs

---

## Types of Storage in Docker (4)

1. Anonymous Volume
2. Named Volume
3. Bind Mount
4. tmpfs (RAM only)

I remember it like this:

anonymous = auto  
named = real storage  
bind = dev work  
tmpfs = secret/fast/temp  

---

## 1. Anonymous Volume

- Created automatically by Docker
- Has a random name
- Example:

```bash
docker run -d -v /data nginx
```

- Docker creates something like:
d3c9248bc5a8f...

- Use when:
  - Short-lived containers
  - You don’t care about the volume name

- Note:
  - Auto removed only if container is started with --rm

---

## 2. Named Volume (Most Important)

- Created by user
- Managed by Docker
- Lives even if container is deleted
- Best for:
  - Databases
  - Uploads
  - App data

Example:

```bash
docker volume create mydata

docker run -d -v mydata:/var/lib/mysql mysql:8
```

Even if container is removed, data stays.

This is what I should use for DB in production.

---

## 3. Bind Mount

- Host folder is mounted directly into container
- Format:

```bash
-v /host/path:/container/path
```

Example:

```bash
docker run -d -v $(pwd)/website:/usr/share/nginx/html nginx
```

- Changes on host = instantly visible in container
- Best for:
  - Local development
  - Config files
  - Logs

Notes:
- Host controls the folder
- Not recommended for production unless needed

---

## 4. tmpfs Mount

- Stored in RAM
- Super fast
- Data is lost when container stops
- Used for:
  - Secrets
  - Cache
  - Temporary files

Example:

```bash
docker run -d --tmpfs /cache nginx
```

tmpfs = speed + security + no persistence

---

## Where Docker Stores Volumes? (Interview Point)

/var/lib/docker/volumes/

Inside:

mydata/_data/

- Docker manages this
- Bind mounts do NOT go here

---

## Quick Comparison (In My Words)

- Anonymous → temporary, auto
- Named → real storage, safe
- Bind → dev work, sync with host
- tmpfs → RAM, fast, gone on stop

---

## My Final Mental Model

- Containers die → data dies
- Volumes exist → data lives
- For DB → always use Named Volume
- For dev → use Bind Mount
- For secrets/cache → use tmpfs

---

## One Line Summary

Volumes are how Docker stops containers from forgetting everything.