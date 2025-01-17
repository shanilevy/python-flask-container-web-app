pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: maven
            image: maven:alpine
            command:
            - cat
            tty: true
          - name: docker
            image: docker:latest
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          volumes:
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock    
        '''
    }
  }
  environment{
      VERSION = "1.${env.BUILD_ID}"
      PROJECT_ID = 'shanilevy-615-2023063002023400'
      CLUSTER_NAME = 'shanilevy-615-2023063002023400-us-west1'
      LOCATION = 'us-west1'
      CREDENTIALS_ID = 'jenkins-sa-gcp'
  }
  stages {
    stage('Checkout') {
        steps {
            checkout scm
        }
    } 

    stage('Build-Docker-Image') {
      steps {
        container('docker') {
          sh 'docker build -t us-west1-docker.pkg.dev/shanilevy-615-2023063002023400/flask-app/flask-app:$VERSION .'
            withDockerRegistry([credentialsId: "gcr:jenkins-sa-gcp", url: "https://us-west1-docker.pkg.dev/shanilevy-615-2023063002023400/flask-app"]) {
                    sh 'docker push us-west1-docker.pkg.dev/shanilevy-615-2023063002023400/flask-app/flask-app:$VERSION'
            }
        }
      }
    }
    stage('Deploy to GKE') {
            steps {
               withCredentials([file(credentialsId: 'mongosecret', variable: 'MONGO_S')]) {
                    sh "sed -i 's/latest/${VERSION}/g' kubernetes_private.yaml"
                    sh "curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kubectl"
                    sh "chmod +x ./kubectl"
                    sh "./kubectl delete secret mongosecret --ignore-not-found"
                    sh "./kubectl create secret generic mongosecret --from-env-file=${env.MONGO_S}"
                    sh "./kubectl apply --filename kubernetes_private.yaml --validate=false"
                    //step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'kubernetes_private.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
                }
            }
        }
  }
}