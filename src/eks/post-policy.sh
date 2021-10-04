test -n "$1" && echo REGION is "$1" || "echo REGION is not set && exit"
test -n "$2" && echo CLUSTER is "$2" || "echo CLUSTER is not set && exit"
test -n "$3" && echo ACCOUNT is "$3" || "echo ACCOUNT is not set && exit"
test -n "$LBC_VERSION" && echo LBC_VERSION is "$LBC_VERSION" || "export LBC_VERSION=2.1.0"


helm repo add eks https://aws.github.io/eks-charts


rm -f crds.yaml*
wget -o crds.yaml https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml
# create the custom resource definition for the load balancer
kubectl apply -f crds.yaml

kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

# install the load balancer controller using the helm chart 
helm upgrade \
    -i aws-load-balancer-controller \
    eks/aws-load-balancer-controller \
    -n kube-system \
    --set clusterName=$2 \
    --set serviceAccount.name=aws-load-balancer-controller \
    --set image.repository=602401143452.dkr.ecr.$1.amazonaws.com/amazon/aws-load-balancer-controller \
    --set image.tag="v2.1.0"


helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=example --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

helm install \
    aws-load-balancer-controller eks/aws-load-balancer-controller \
    -n kube-system \
    --set clusterName=<cluster-name>
