pipeline {
  agent any
  tools {
      maven "maven"
  }

  stages {
    stage ('STAGE 1-build and test') {
      when { branch "feature/*" }
      steps {
        configFileProvider([configFile(fileId: "mvn-settings", variable: "MAVEN_SETTINGS")]) {
            sh 'mvn verify -s $MAVEN_SETTINGS'
        sh 'docker build -t feature:${env.BUILD_NUMBER} ./Dockerfile'
        sh 'docker run --name app -p 8083:8083 --network suggest-lib_my_net'
        sh 'docker run --name test --network suggest-lib_my_net'
        sh 'curl app:8083'
        sh 'docker exec test "./e2e_test.py app:8083"'
        sh 'docker rm -f /test /app'
        }
      }
    }
    stage ('STAGE 2 build, test and publish image') {
      when { branch "main" }
      steps {
        configFileProvider([configFile(fileId: "mvn-settings", variable: "MAVEN_SETTINGS")]) {
        sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/c7o8u9c1'        
        sh 'docker build -t toxicapp: .'
        sh 'docker run --name app -p 8083:8083 --network suggest-lib_my_net'
        sh 'docker run --name test --network suggest-lib_my_net'
        sh 'curl app:8083'
        sh 'docker exec test "./e2e_test.py app:8083"'
        sh 'docker rm -f /test /app'
        sh 'docker tag toxicapp:${env.BUILD_NUMBER} public.ecr.aws/c7o8u9c1/toxicapp:${env.BUILD_NUMBER}'
        sh 'docker push public.ecr.aws/c7o8u9c1/toxicapp:${env.BUILD_NUMBER}'
      }
    }
  }
    stage ('STAGE 3 deploy app on aws instance') {
      when {branch "main"}       
      steps {
        sh './cd.sh 52.205.112.131'
      }
    }
  }
}

