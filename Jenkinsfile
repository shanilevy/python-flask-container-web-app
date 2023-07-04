pipeline {
    agent any 

	  environment {
		    DOCKERHUB_CREDENTIALS = credentials('docker-creds')
	  }

    stages {
        stage('Build Docker Image with new code') {
             // build docker image
            dockerImage = docker.build("us-west1-docker.pkg.dev/shanilevy-615-2023063002023400/flask-app/flask-app:${env.BUILD_NUMBER}")
        }
      
        stage('Test') { 
            agent any
            steps {
                echo 'No test is being performed. Shown for demo purposes.'
                echo 'Test Stage Complete'
            }
        }
        stage('Docker Login') {
            steps {
                script {
                    docker.withRegistry('us-west1-docker.pkg.dev', 'gcr:jenkins-sa') {
                        dockerImage.push()
                    }
                }
			} 
        }

    }
}