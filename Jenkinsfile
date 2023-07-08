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
      CREDENTIALS_ID = 'gke'
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
            withDockerRegistry([credentialsId: "gcr:gke", url: "https://us-west1-docker.pkg.dev/shanilevy-615-2023063002023400/flask-app"]) {
                    //sh 'docker tag ${IMAGE_NAME}:${IMAGE_TAG} LOCATION-docker.pkg.dev/${PROJECT}/${REPOSITORY}/${IMAGE_NAME}:${IMAGE_TAG}'
                    sh 'docker push us-west1-docker.pkg.dev/shanilevy-615-2023063002023400/flask-app/flask-app:$VERSION'
            }
        }
      }
    }
    stage('Deploy to GKE') {
            steps {
                //sh "sed -i 's/hello:latest/hello:${env.BUILD_ID}/g' deployment.yaml"
                //sh "sed -i 's/TEST_IMAGE_NAME/us-west1-docker.pkg.dev/shanilevy-615-2023063002023400/flask-app/flask-app:f16546c6c2b5d61729c0411b776b322ab5883591/g' kubernetes_private.yaml"
                withCredentials([file(credentialsId: 'mongosecret', variable: 'MONGO_S')]) {
                    sh '''
                            sed -i 's|TEST_IMAGE_NAME|us-west1-docker.pkg.dev/shanilevy-615-2023063002023400/flask-app/flask-app:${VERSION}|' kubernetes_private.yaml
                    '''
                    sh "curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kubectl"
                    sh "chmod +x ./kubectl"
                    sh "./kubectl delete secret mongosecret --ignore-not-found"
                    sh "./kubectl create secret generic mongosecret --from-env-file=${env.MONGO_S}"
                    sh "cat kubernetes_private.yaml"
                    sh "./kubectl apply --filename kubernetes_private.yaml --validate=false"
                    //step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'kubernetes_private.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
                }
            }
        }
  }
}