pipeline {
  agent any
  tools {
      maven "maven"
  }
  parameters {
    string(name: 'IP_PROD', defaultValue: "0", description: 'enter ip addres of prod instance')
  }
  stages {
    stage ('STAGE 1-build and test') {
      when { branch "feature/*" }
      steps {
        configFileProvider([configFile(fileId: "mvn-settings", variable: "MAVEN_SETTINGS")]) {
            sh 'mvn verify -s $MAVEN_SETTINGS'
        }
        sh 'docker build -t feature:${env.BUILD_NUMBER} .'
        sh 'docker build -f Dockerfile.test -t testimage:lts .'

        sh "docker run --name app --network suggest-lib_my_net -d toxicapp:${env.BUILD_NUMBER}"
        sh 'docker run --name test --network suggest-lib_my_net testimage:lts'
      }
    }
    stage ('STAGE 2 build, test and publish image') {
      when { branch "main" }
      steps {
        sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/c7o8u9c1'
        configFileProvider([configFile(fileId: "mvn-settings", variable: "MAVEN_SETTINGS")]) {
          sh 'mvn verify -s $MAVEN_SETTINGS' 
        sh "docker build -t toxicapp:${env.BUILD_NUMBER} ."
        sh "docker run --name app --network suggest-lib_my_net -d toxicapp:${env.BUILD_NUMBER}"
        sh 'docker build -f Dockerfile.test -t testimage:lts .'
        sh 'sleep 10'
        sh 'docker run --name test --network suggest-lib_my_net testimage:lts'
        sh "docker tag toxicapp:${env.BUILD_NUMBER} public.ecr.aws/c7o8u9c1/toxicapp:${env.BUILD_NUMBER}"
        sh "docker push public.ecr.aws/c7o8u9c1/toxicapp:${env.BUILD_NUMBER}"
      }
    }
  }
    stage ('STAGE 3 deploy app on prod') {
      when {branch "main"}       
      steps {
        sh "./cd.sh '3.90.148.147'"
      }
    }
  }  
  post {
    always {
      sh 'docker rm -f /app /test'
      sh "docker image rm toxicapp:${env.BUILD_NUMBER} testimage:lts"
    }  
    failure{
      echo 'you faild'
    }
    success{
      echo 'nice job!'
    }
  } 
}
