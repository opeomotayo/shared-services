#!/bin/bash

#echo "Script created by Ali Abbas(aliabbas199555@gmail.com) "
read -p 'Enter Namespace: ' NAMESPACE
read -p 'Enter Email: ' EMAIL
read -p 'Enter DomainName: ' DOMAIN
read -p 'Enter IngressName: ' INGRESSNAME
#read -sp 'Enter Secret: ' SECRET

#if [ "$SECRET" = allowme ]; then
cat << EOF >> staging-issuer.yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-staging
  namespace: $NAMESPACE
spec:
  acme:
    # Staging API
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: $EMAIL
    privateKeySecretRef:
      name: account-key-staging
    solvers:
    - http01:
       ingress:
         class: nginx
EOF

kubectl create -f staging-issuer.yaml -n $NAMESPACE

rm -f staging-issuer.yaml

cat << EOF >> production-issuer.yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-production
  namespace: $NAMESPACE
spec:
  acme:
    # Staging API
    server: https://acme-v02.api.letsencrypt.org/directory
    email: $EMAIL
    privateKeySecretRef:
      name: account-key-production
    solvers:
    - http01:
       ingress:
         class: nginx
EOF

kubectl create -f production-issuer.yaml -n $NAMESPACE

rm -f production-issuer.yaml

kubectl patch ingress $INGRESSNAME -p '{"metadata": {"annotations":{"cert-manager.io/issuer":"letsencrypt-staging"}}}' -n $NAMESPACE

kubectl patch ingress $INGRESSNAME -p '{ "spec": { "tls": [{"hosts": ["'$DOMAIN'"],"secretName": "'$NAMESPACE'-staging-certificate"}]}}' -n $NAMESPACE

cat << EOF >> staging-certificate.yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: $NAMESPACE-staging
  namespace: $NAMESPACE
spec:
  secretName: $NAMESPACE-staging-certificate
  issuerRef:
    name: letsencrypt-staging
  dnsNames:
  - $DOMAIN

EOF
kubectl create -f staging-certificate.yaml -n $NAMESPACE
rm -f  staging-certificate.yaml

kubectl patch ingress $INGRESSNAME -p '{"metadata": {"annotations":{"cert-manager.io/issuer":"letsencrypt-production"}}}' -n $NAMESPACE

kubectl patch ingress $INGRESSNAME -p '{ "spec": { "tls": [{"hosts": ["'$DOMAIN'"],"secretName": "'$NAMESPACE'-production-certificate"}]}}' -n $NAMESPACE

cat << EOF >> production-certificate.yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: $NAMESPACE-production
  namespace: $NAMESPACE
spec:
  secretName: $NAMESPACE-production-certificate
  issuerRef:
    name: letsencrypt-production
  dnsNames:
  - $DOMAIN
    
EOF
kubectl create -f production-certificate.yaml -n $NAMESPACE
rm -f  production-certificate.yaml

#fi
