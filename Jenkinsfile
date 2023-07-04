pipeline {
    agent any 

	// stage('Checkout') {
    //     steps {
    //         checkout scm
    //     }

    // }
    stage('Clone Repo') { 
      // Get some code from a GitHub repository
      git url:'https://github.com/shanilevy/python-flask-container-web-app.git',branch:'main' //update your forked repo
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