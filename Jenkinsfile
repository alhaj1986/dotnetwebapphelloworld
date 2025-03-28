pipeline {
  agent any

  environment {
      
    AWS_REGION = 'us-east-1'
    ECR_REPO_NAME = 'dotnethelloworld'
    IMAGE_TAG = 'latest'
    AWS_ACCOUNT_ID = '920373030046'
    SONAR_SCANNER_HOME = tool 'ibs-sonar'
   
    

  }

  stages {
    stage('Git') {
      steps {
        git branch: 'main', credentialsId: 'alhajgit', url: 'https://github.com/alhaj1986/dotnetwebapphelloworld.git'
      }
    }

    stage('Build') {
      steps {
        sh 'dotnet build'
      }
    }
    
     stage('Test') {
      steps {
        sh 'dotnet test'
      }
    }
    
    stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('ibs-sonar') {
                    sh "$SONAR_SCANNER_HOME/bin/sonar-scanner"
                }
            }
        }
    
    
     stage('Docker Build') {
      steps {
        script {
          docker.build("${env.ECR_REPO_NAME}:${env.IMAGE_TAG}", "-f hello-world-dotnet/Dockerfile hello-world-dotnet")
        }
      }
    }
    
   stage('Trivy Scan') {
  steps {
    script {
      // Run Trivy scan and always return success
      sh "trivy image --severity HIGH,CRITICAL ${env.ECR_REPO_NAME}:${env.IMAGE_TAG} || true"
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
 
          sh '''
          if [ $(docker ps -a -q -f name=dotnethelloworld_container) ]; then
            docker rm -f dotnethelloworld_container
          fi
          '''
       
          sh '''
          docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}
          '''
      
          sh '''
          docker run -d --name dotnethelloworld_container -p 5000:80 ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}
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
