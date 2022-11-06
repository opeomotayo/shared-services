# Step 01
#### install kubeseal on macOS
```yaml
brew install kubeseal
```
#### install kubeseal on linux
```yaml
wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.16.0/kubeseal-linux-amd64 -O kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
```
# Step 02
#### install sealed-secrets-controller with helm
```yaml
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo update
helm install sealed-secrets-controller -n kube-system sealed-secrets/sealed-secrets
```
#### install sealed-secrets-controller with yaml manifest
```yaml
kubectl apply -f "https://github.com/kasunsjc/sealed-secret-with-kubernetes/blob/main/bitnami-sealed-controller/controller.yaml" -n kube-system
```

#### troubleshooting commands
```yaml
kubectl get pods -l name=sealed-secrets-controller -n kube-system
kubectl logs --tail=-1 -f -l name=sealed-secrets-controller -n kube-system
kubectl get secrets -n kube-system
kubectl get secrets sealed-secrets-key6676z -o yaml -n kube-system
```
# Step 03
#### create sealed-secret and secret
```yaml
kubectl apply -f 01-namespace.yaml
kubeseal --fetch-cert > cert.pem #cert to encrypt the secrets
openssl x509 -in cert.pem -text -noout #decode the cert
kubeseal < 02-secret.yaml --cert cert.pem -o yaml > 03-sealed-secret.yaml #create sealed-secret yaml
kubectl apply -f 03-sealed-secret.yaml #apply the sealed-secret yaml
kubectl logs --tail=-1 -f -l name=sealed-secrets-controller -n kube-system #check to confirm it's unsealed
kubectl get sealedsecrets -n staging #check for the created sealed secret
kubectl get secrets -n staging #check for the created secret
kubectl get secrets credentials -o yaml -n staging
kubectl get secrets credentials -o jsonpath='{.data}' -n staging
echo "JDMjKjIxMzRhc2Q=" | base64 -d
kubectl get secrets credentials -o jsonpath='{.data}' -n staging | jq -r '.token' | base64 -d
kubectl apply -f 04-deployment.yaml
kubectl get po -n staging
kubectl logs -l app=flask -n staging
```
