# Sealed Secrets & KubeSeal

## 1. Install helm chart for deploying sealed secret manually.

```sh
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets
```

## 2. Installing Kubeseal command:

> The kubeseal CLI tool is used to encrypt sensitive data. Install it from https://github.com/bitnami-labs/sealed-secrets/releases

Linux

The kubeseal client can be installed on Linux, using the below commands:

```sh

KUBESEAL_VERSION='' # Set this to, for example, KUBESEAL_VERSION='0.28.0'
curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION:?}/kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz"
tar -xvzf kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
```
> source : https://github.com/bitnami-labs/sealed-secrets?tab=readme-ov-file#installation

## 3. Encrypting secrets

```sh
kubeseal --controller-name=sealed-secrets --controller-namespace=kube-system < mysql-secret.yaml > mysql-sealed-secret.yaml`
```

> source : https://harsh05.medium.com/managing-secrets-in-gitops-a-deep-dive-into-kubernetes-secrets-and-sealed-secrets-f7f201eb5d60