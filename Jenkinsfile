pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    ECR_REPO_NAME = 'dotnetcorewebapp'
    IMAGE_TAG = 'latest'
    AWS_ACCOUNT_ID = '920373030046'
  }

  stages {
    stage('Git') {
      steps {
        git credentialsId: 'alhajgit', url: 'https://github.com/alhaj1986/dotnetwebapphelloworld.git'
      }
    }

    stage('Build') {
      steps {
        sh 'dotnet build'
      }
    }
    
  
    stage('Docker Build') {
      steps {
        script {
          docker.build("${env.ECR_REPO_NAME}:${env.IMAGE_TAG}")
        }
      }
    }

    stage('Push to ECR') {
      steps {
        script {
       
          sh '''
          aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 920373030046.dkr.ecr.us-east-1.amazonaws.com
          '''

 
          sh '''
          docker tag dotnethelloworld:latest 920373030046.dkr.ecr.us-east-1.amazonaws.com/dotnethelloworld:latest
          '''

    
          sh '''
          docker push 920373030046.dkr.ecr.us-east-1.amazonaws.com/dotnethelloworld:latest
          '''
        }
      }
    }
  stage('Run Container') {
      steps {
        script {
          // Remove existing container if it exists
          sh '''
          if [ $(docker ps -a -q -f name=dotnetcorewebapp_container) ]; then
            docker rm -f dotnetcorewebapp_container
          fi
          '''

          // Pull the latest image from ECR
          sh '''
          docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}
          '''

          // Run the container
          sh '''
          docker run -d --name dotnetcorewebapp_container -p 8090:8085 ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}
          '''
        }
      }
    }
  }

  post {
    success {
      cleanWs()
    }
  }
}
