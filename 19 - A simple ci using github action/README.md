# GitHub Actions — Personal Revision Notes

## What is GitHub Actions?

> GitHub Actions lets you run automated tasks when something happens in your repository.

Examples:
- When code is pushed → build the app
- When PR is created → run tests

These automated tasks are called **Workflows** and are written in **YAML**.

---

## Why We Use GitHub Actions

- Built into GitHub
- No extra CI server needed
- Easy to:
  - Build
  - Test
  - Package
  - Deploy
- Supports:
  - Linux
  - Windows
  - Mac

---

## Basic Terms (Must Remember)

| Term | Meaning |
|------|--------|
| Workflow | Full automation (YAML file) |
| Job | A set of steps |
| Step | One action or command |
| Runner | Machine that runs job |
| Action | Reusable automation code |

---

## Project Structure (Java Example)

```text
java-github-actions-demo/
├── src/
│   └── Main.java
├── pom.xml
└── .github/
    └── workflows/
        └── build.yml
```

---

## Where Workflow Files Live

> Always inside:

```text
.github/workflows/
```

Example:

```text
.github/workflows/build.yml
```

---

## Basic Workflow File (Mental Template)

```yaml
name: My Workflow
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Hello"
```

---

## Java + Maven Example Workflow

```yaml
name: Java Build Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'

      - name: Build with Maven
        run: mvn clean package
```

---

## What Happens When You Push Code?

1. GitHub detects push to main
2. Creates a VM (runner)
3. Checks out code
4. Installs Java
5. Runs Maven build
6. Shows:
   - Green tick = success
   - Red cross = failure

---

## Where to See Output

- Go to:
  > GitHub Repo → Actions tab → Click workflow → See logs

---

## Using Maven in GitHub Actions

- setup-java installs Java
- mvn clean package:
  - Compiles code
  - Runs tests
  - Builds JAR/WAR

---

## Caching (Concept)

> Caching Maven dependencies = faster builds

(Used in real projects to reduce build time)

---

## Important Commands Used

```bash
git clone <repo-url>
mvn clean package
```

---

## Common Mistakes (Very Important)

| Mistake | Fix |
|--------|------|
| Wrong Java version | Match with pom.xml |
| Missing .github/workflows | Folder name must be exact |
| YAML indentation error | Use spaces, not tabs |
| Maven not found | Use setup-java action |

---

## Cost Awareness (Cloud Runners)

- GitHub provides free minutes (limited)
- Long jobs = more cost
- Always:
  - Stop unused workflows
  - Optimize build time

---

## My Mental Model

- Workflow = pipeline
- Job = stage
- Step = command
- Runner = machine
- Action = helper

---

## One Line Summary

> GitHub Actions is GitHub’s built-in CI/CD system that runs automated workflows when events like push or PR happen.