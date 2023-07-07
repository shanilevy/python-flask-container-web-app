pipeline {
    agent any 
    environment {
        PROJECT_ID = 'shanilevy-615-2023063002023400'
        CLUSTER_NAME = 'shanilevy-615-2023063002023400'
        LOCATION = 'us-west1'
        CREDENTIALS_ID = 'shanilevy-615-2023063002023400'
    }
    //agent  {
    //    label 'dind-agent'
    //}
    // stage('Clone Repo') { 
    //   // Get some code from a GitHub repository
    //   git url:'https://github.com/shanilevy/python-flask-container-web-app.git',branch:'main' //update your forked repo
    // }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        // stage('Build image') {
        //     steps {
        //         //container('docker') {
        //          //   sh 'docker build -t us-west1-docker.pkg.dev/shanilevy-615-2023063002023400/flask-app/flask-app:${env.BUILD_ID} .'
        //          //}
        //         //  script {
        //         //     sh "docker build -t us-west1-docker.pkg.dev/shanilevy-615-2023063002023400/flask-app/flask-app:${env.BUILD_ID} ."
        //         // }
                 
        //         script {
        //             app = docker.build("us-west1-docker.pkg.dev/shanilevy-615-2023063002023400/flask-app/flask-app:${env.BUILD_ID}")
        //         }
        //     }
        // }
      
        stage('Test') { 
            steps {
                echo 'No test is being performed. Shown for demo purposes.'
                echo 'Test Stage Complete'
            }
        }
        stage('Deploy to GKE') {
            // steps{
            //     //sh "sed -i 's/hello:latest/hello:${env.BUILD_ID}/g' deployment.yaml"
            //     step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'kubernetes_private.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
            // }
            steps {
                //kubernetes {
                    //cloud 'kubernetes'
                    sh 'kubectl get pods'
                //}
                // Create namespace if it doesn't exist 
            }
        }
        // stage('Docker Login') {
        //     steps {
        //         script {
        //             docker.withRegistry('us-west1-docker.pkg.dev', 'gcr:jenkins-sa') {
        //                 dockerImage.push()
        //             }
        //         }
		// 	} 
        // }

    }
}