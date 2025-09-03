# SecureCloudShop

End-to-end **DevSecOps** demo using only **free tiers / open source**.
Shows CI/CD, containerization, IaC, security scanning, and Kubernetes deployment.

## Features
- Flask demo app (products API)
- Dockerized build
- GitHub Actions CI (Trivy image scan + ZAP baseline)
- GitHub CodeQL (SAST)
- Helm chart + raw Kubernetes manifests
- Terraform that deploys the Helm chart into your **current kube-context** (kind / Rancher Desktop / minikube) — **no cloud required**

## Quickstart

### 1) Run locally
```bash
docker compose up --build
# visit http://localhost:5000 and /products
```

### 2) Kind cluster (free, local)
```bash
# Install kind: https://kind.sigs.k8s.io/
kind create cluster --name securecloudshop
kubectl get nodes

# Build & load the image into kind
IMAGE=ghcr.io/your-org/securecloudshop:latest
docker build -t $IMAGE .
kind load docker-image $IMAGE --name securecloudshop

# Helm install
helm upgrade --install securecloudshop ./helm/securecloudshop   --set image.repository=ghcr.io/your-org/securecloudshop   --set image.tag=latest

kubectl get svc
kubectl port-forward svc/securecloudshop 8080:80
# visit http://localhost:8080
```

### 3) Terraform apply (deploy Helm via Terraform)
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

> Terraform expects your kubeconfig at `~/.kube/config` by default. Override with `-var="kubeconfig_path=/path/to/config"`.

## CI/CD & Security

- **CI**: build, Trivy scan, ZAP baseline DAST.
- **CodeQL**: static analysis for Python.
- **CD**: pushes image to GHCR and publishes Helm chart artifact.

## Customize
- Replace `ghcr.io/your-org/securecloudshop` with your GHCR path.
- Add tests (pytest), then enable fail-on-severity for Trivy.
- Enable Ingress in Helm and configure domain if using an ingress controller.
