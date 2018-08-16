# PKS Pipeline

**This pipeline is intended for demo or dev purposes**

![image](https://user-images.githubusercontent.com/106908/38229102-fefedcfe-3741-11e8-9c7f-f19460bc9d06.png)

##  How to create a PKS cluster

```
PKS_USER=demo@example.com
PKS_PASSWORD=demodemo1234

GCP_REGION=asia-northeast1
CLUSTER_NAME=pks-demo1
```

The following instruction shows how to create a cluster named "${CLUSTER_NAME}"

### Grant Cluster Access to a User     

```     
uaac target ${UAA_URL} --skip-ssl-validation
uaac token client get admin -s ${ADMIN_SECRET}
uaac user add ${PKS_USER} --emails ${PKS_USER} -p ${PKS_PASSWORD}
uaac member add pks.clusters.admin ${PKS_USER}
```

### Log in to PKS

```
pks login -k -a ${PKS_API_URL} -u ${PKS_USER} -p ${PKS_PASSWORD}
```

### Create an external load balancer for ${CLUSTER_NAME} cluster

```
gcloud compute addresses create ${CLUSTER_NAME}-master-api-ip --region ${GCP_REGION}
gcloud compute target-pools create ${CLUSTER_NAME}-master-api --region ${GCP_REGION}
```

### Create a Cluster

```
MASTER_EXTERNAL_IP=$(gcloud compute addresses describe ${CLUSTER_NAME}-master-api-ip --region ${GCP_REGION} --format json | jq -r .address)
pks create-cluster ${CLUSTER_NAME} -e ${MASTER_EXTERNAL_IP} -p small -n 1
```

### Configure your external load balancer to point to the master vm

```
CLUSTER_UUID=$(pks clusters | grep ${CLUSTER_NAME} | awk '{print $3}')
MASTER_INSTANCE_NAME=$(gcloud compute instances list --filter "tags:service-instance-${CLUSTER_UUID}-master" | awk 'NR>1 {print $1}')
MASTER_INSTANCE_ZONE=$(gcloud compute instances list --filter "tags:service-instance-${CLUSTER_UUID}-master" | awk 'NR>1 {print $2}')
gcloud compute target-pools add-instances ${CLUSTER_NAME}-master-api \
        --instances ${MASTER_INSTANCE_NAME} \
        --instances-zone ${MASTER_INSTANCE_ZONE} \
        --region ${GCP_REGION}
gcloud compute forwarding-rules create ${CLUSTER_NAME}-master-api-8443 \
        --region ${GCP_REGION} \
        --address ${CLUSTER_NAME}-master-api-ip \
        --target-pool ${CLUSTER_NAME}-master-api  \
        --ports 8443
```

### Access your cluster

```
pks get-credentials ${CLUSTER_NAME}
kubectl cluster-info
```