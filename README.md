# expert-octo-pancake (Kubernetes)

Практическая работа №10

### Развертывание с помощью kubectl

Примените все манифесты, используя утилиту `kubectl`:

```bash
kubectl apply -f manifests/
```

### Развертывание с помощью Helm

Установка релиза с помощью утилиты `helm` в Namespace `production`:

```bash
helm install my-release ./helm-charts/my-web-app -n production --create-namespace
```
