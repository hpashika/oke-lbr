# oke-lbr
Using an OCI LBR to frontend Multiple Kubernetes Services without an Ingress Controller

* Create Kubernetes Services 
kubectl apply -f ./oke/nginx-nodeport.yaml

kubectl get all
$>kubectl get all 

NAME                                  READY   STATUS    RESTARTS   AGE
pod/my-nginx-green-68bdf6b7f6-k8sgf   1/1     Running   0          3h37m
pod/my-nginx-green-68bdf6b7f6-s9qjd   1/1     Running   0          3h37m
pod/my-nginx-green-68bdf6b7f6-snnks   1/1     Running   0          3h37m
pod/my-nginx-red-747f49594d-26q8n     1/1     Running   0          3h37m
pod/my-nginx-red-747f49594d-mbt9n     1/1     Running   0          3h37m
pod/my-nginx-red-747f49594d-pdnlr     1/1     Running   0          3h37m

NAME                         TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
service/my-nginx-green-svc   NodePort   172.17.183.182   <none>        80:31186/TCP   3h37m
service/my-nginx-red-svc     NodePort   172.17.170.144   <none>        80:31211/TCP   3h37m

NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/my-nginx-green   3/3     3            3           3h37m
deployment.apps/my-nginx-red     3/3     3            3           3h37m

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/my-nginx-green-68bdf6b7f6   3         3         3       3h37m
replicaset.apps/my-nginx-red-747f49594d     3         3         3       3h37m

* Create LBR
Use OCI Stacks to create the resources
Below values need to be updated.
- compartment_id : Compartment ID where LBR needs to be created.
- subnet_id      : Subnets for the LBR resources, make sure it is regional subnet.
- lbr_display_name : Display name for the variable
- red_node_port : Node port allocated red service.
- green_node_port : Node port allocated green service.
- nodes : Node ips of your Node Pool, you can get the ip's using kubectl get nodes 

* Access the service using the LBR

curl http://lbr-ip:80/red/index.html
curl http://lbr-ip:80/red/index.html

lbr-ip : IP address assigned to your LBR.

