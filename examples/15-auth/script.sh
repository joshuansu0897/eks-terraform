# ver toda la configuracion del cluster
kubectl config view --raw -o json

# tomamos el certificado de un usuario
kubectl config view --raw -o json | jq -r '.users[1].user[\"client-certificate-data\"]'

# decodificamos el certificado y tomamos el Subject
kubectl config view --raw -o json | jq -r '.users[1].user[\"client-certificate-data\"]'| base64 -d | openssl x509 -text | grep Subject