# show service account
kubectl get serviceaccounts
# or
kubectl get sa

# show default service account
kubectl get sa default -o yaml

# show the secret of the default service account
kubectl get sa default -o json | jq -r '.secrets[0].name'

# get the secret of the default service account
kubectl get secret $(kubectl get sa default -o json | jq -r '.secrets[0].name') -o yaml

# decode the secret of the default service account
kubectl get secret $(kubectl get sa default -o json | jq -r '.secrets[0].name') -o json | jq -r '.data.token' | base64 -d

# use the decripted token to login to the cluster
curl -k https://<cluster-ip> -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6InVMUmNIUnpuNEFWNXdyaERLSFQzVi0yMnIwVmdkYXprR1JRby1FSkVEYTAifQ.eyJpc3MiOiJrdWJlcm....."