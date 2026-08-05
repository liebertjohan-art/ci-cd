# Remote Public Builder Documentation 🛠️

This directory contains resources and templates for integrating private repositories with our remote public builder. The builder operates on GitHub Actions and supports automatic toolchain setups, extreme caching, and fast artifact generation.

## 🚀 How It Works

1. **Your Private Repo:** Contains the code and a trigger action (`TRIGGER_TEMPLATE.yml`).
2. **Cloudflare Worker:** Safely authenticates your request and forwards it to the Public Builder. It acts as an API Gateway.
3. **Public Builder Repo:** Fetches your code using your `MAIN_ACCOUNT_PAT` (Private Access Token), builds it according to your `build.sh`, blocks secrets from leaking, and pushes the securely bundled artifacts into your private **Artifacts Vault** repository.
4. **Telegram Bot:** Safely delivers a notification with download links to your chat once the build finishes.

---

## 🛠️ Getting Started for New Private Repositories

If you have a new private repository and want to build it using this architecture, follow these steps:

### 1. Add the Trigger Workflow
Copy the contents of [`TRIGGER_TEMPLATE.yml`](TRIGGER_TEMPLATE.yml) into your new private repository at the following location:
`.github/workflows/trigger-build.yml`

Make sure to adjust the `payload` block in the cURL request to match your repository (e.g., set the correct `artifact_path` and `build_type`).

### 2. Set Up Secrets inside your Private Repository
Go to your private repository's **Settings > Secrets and variables > Actions** and add:
- `WORKER_AUTH`: The auth token strictly used for communicating with the CF worker securely.

*Note: The `WORKER_URL` is hardcoded in the template by default. Just ensure the domains match.*

### 3. Create a `build.sh` Configuration Script
Your repository **must** include a `build.sh` script at its root. This script tells the execution engine how to compile your code.

- See [`build.sample.sh`](build.sample.sh) for examples of targeting Node, Android, Gradle, NDK implementations, and custom binary builds.
- Commit this script as `build.sh` to the root of your newly created repository.

---

## 📦 Supported `build_type` Environments

You can explicitly ask the builder to pre-install cached tools by sending these configurations inside your trigger payload:

| `build_type` payload | Environment Capabilities Provided Automatically |
|----------------------|-----------------------------------------------|
| `android-gradle`     | Pre-installs Java JDK (`temurin` 17). Ready to run Gradle wrapper commands. Generates caches explicitly based on source repository parameters. |
| `ndk-cmake`          | Pre-installs Android NDK (`r26d`). Binds global variables for NDK path inclusion required for SO binary compiling. |
| `node` / `nextjs`    | Pre-installs Node.js (`20`). Fast native NPM caches generated contextually on runner limits. |
| `custom`             | Clean `ubuntu-latest` execution environment to set up bespoke instructions from scratch inside `build.sh`. |

> **Advanced Overrides:** If you need to bump versions explicitly from your webhook payload, supply fields like `java_version: "21"`, `node_version: "18"`, or `ndk_version: "r26c"`! 

---

## 🔒 Security Posture

- **Untrusted Code Execution Isolation:** The CI/CD engine explicitly strips R2/cloud storage secrets from environment exposure contexts before triggering the user's workspace.
- **Log Masking:** GitHub masks pre-defined platform secrets recursively across step logs.
- **Artifact Protection:** All bundled resources fallback into an entirely disjointed repository dedicated explicitly for vault releases, shielding source code dependencies.
