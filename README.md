My steps for doing the task



Your Task:
1 - Connect by SSH to the VM with the key file
# Command for the connection:
ssh -i ./gleb.pem azureuser@20.103.250.163


2 - Install any required CLI tool (Hint: you’ll need azure CLI, kubectl, helm)
    Installed az, kubectl, helm, docker and jenkins
    

3 - Login to the azure using “managed identity”
# Command for the login with "managed identity"
az login --identity


4 - Connect to the following Kubernetes cluster as admin
	AKS name: gleb-interview-aks
       Resource group: devops-interview-rg
# Command to connect to the k8s cluster with as admin
az aks get-credentials --admin --resource-group devops-interview-rg --name gleb-interview-aks


5 - Install ingress nginx controller
#Create a namespace for your ingress resources
kubectl create namespace ingress-basic

# Add the ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Use Helm to deploy an NGINX ingress controller
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-basic \
    --set controller.replicaCount=1 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux
# You can watch the status by running
kubectl --namespace ingress-basic get services


6 - Create and deploy helm chart for the following application:
    Image: simple-web
    Registry: acrinterview.azurecr.io   
# To Pull the image to localhost:
sudo az acr login --name acrinterview
sudo docker pull acrinterview.azurecr.io/simple-web
# Change values in the deployment.yaml and in the values.yaml - then run:
helm install glebchart glebapp/
# Some cleanup commands
kubectl delete 'deployment.apps/glebchart'
kubectl delete 'service/glebchart'
helm uninstall 'glebchart'


 7 - ** Please add the Helm chart to your own Github repo

 8 - Add to the helm charts template HPA and ingress rule

 9 - Check access from public IP to the simple-app
 # Go to browser and enter the load balancer ip with the port :8000

 10 - Bonus task: Install Jenkins on the Linux VM and create a pipeline for deploying the helm chart from the repo.
 # To Install jenkins:
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
        /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install jenkins
 # To connect the server - http://publicserverip:8080
 # Can locate the public server ip using curl

 - Once you are done, Please send the link to your repo along with the explanation of what you did write in a README.md file.
 - Don’t forget to include the login credentials for accessing your created Jenkins.
 
 - Credetials:
    Admin
    Aa123456
    
pipeline {
    agent any

    stages {
        stage('Git Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/bamb4boy/helm_charts'
            }
        }
        stage('deploy helm') {
            steps {
                sh '''/var/lib/jenkins/workspace/deploy-helm-chart/run_helm.sh
'''
            }
        }
    }
}

