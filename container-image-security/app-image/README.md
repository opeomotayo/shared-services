# S3C Demo

A lot of the inspiration for this demo comes from [here](https://marcofranssen.nl/secure-your-software-supply-chain-using-sigstore-and-github-actions)

## Instructions

Verify the image

```bash
COSIGN_EXPERIMENTAL=1 cosign verify mattiasgees/s3c-demo:main | jq
```

Verify the SBOM attestation

```bash
COSIGN_EXPERIMENTAL=1 cosign verify-attestation mattiasgees/s3c-demo:main --type spdxjson | jq
```

Get SBOM artifact

```bash
COSIGN_EXPERIMENTAL=1 cosign verify-attestation mattiasgees/s3c-demo:main --type spdxjson | jq '.payload |= @base64d | .payload | fromjson | select(.predicateType == "https://spdx.dev/Document") | .predicate.Data'
```

```bash
COSIGN_EXPERIMENTAL=1 cosign verify-attestation mattiasgees/s3c-demo:main --type spdxjson | jq '.payload |= @base64d | .payload | fromjson | select(.predicateType == "https://spdx.dev/Document") | .predicate.Data' > sbom-spdx.json
```

Scan for CVEs

```bash
grype sbom:./sbom-spdx.json
trivy sbom sbom-spdx.json
```

Get SLSA Provenance

```bash
COSIGN_EXPERIMENTAL=1 cosign verify-attestation mattiasgees/s3c-demo:main --type slsaprovenance | jq '.payload |= @base64d | .payload | fromjson'
```

Copy Container Image

```bash
cosign copy mattiasgees/s3c-demo:main gcr.io/jetstack-mattias/s3c-demo:test
```

Show and apply policy

```bash
kubectl get pods -n cosign-system
kubectl apply -f policy
kubectl describe clusterimagepolicies.policy.sigstore.dev
```

Apply Kubernetes

```bash
kubectl apply -f kubernetes
```

Change tag to test

```bash
kubectl apply -f kubernetes
```
