pipeline{
    agent any
    tools { 
        maven 'maven' 
         
    }
    environment{
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "44.202.65.98:8081"
        
    }
    stages{
        stage('Git Checkout'){
            steps{
                git url: 'https://github.com/piya199616/demo-counter-app.git' ,branch: 'main'
            }
           
        }

       stage('Unit testing'){
            steps {
                sh 'mvn test'
        }
       }

       stage('Integration testing'){
            steps {
                sh 'mvn verify -DskipUnitTests'
        }
       }

       stage('Maven Build'){
            steps{
                sh 'mvn clean install'
        }
       }
       stage('Static Code Analysis'){
        steps{
            withSonarQubeEnv('sonarqube') {
                sh 'mvn clean package sonar:sonar'
              }
        }
       }
       stage("Quality Gate") {
            steps { 
                waitForQualityGate abortPipeline: false , credentialsId: 'sonar-api'
                 
            }
       }
       stage('Nexus artifact upload'){
        steps{
            script{
                def pom = readMavenPom file: 'pom.xml'
                def nexusRepo = pom.version.endsWith("SNAPSHOT") ? "demo-app-snapshots" : "demo-app-release"
            nexusArtifactUploader artifacts: [[
                artifactId: 'springboot', 
                classifier: '', 
                file: 'target/Uber.jar', 
                type: 'jar'
                ]], 
                credentialsId: 'nexus-auth', 
                groupId: 'com.example', 
                nexusUrl: NEXUS_URL, 
                nexusVersion: NEXUS_VERSION, 
                protocol: NEXUS_PROTOCOL, 
                repository: nexusRepo, 
                version: "${pom.version}"
            }
            
        }
       }

       stage('Docker build'){
        steps{
            sh 'docker build -t $JOB_NAME:v1.$BUILD_ID .'
            sh 'docker tag $JOB_NAME:v1.$BUILD_ID pburela/$JOB_NAME:v1.$BUILD_ID'
            sh 'docker tag $JOB_NAME:v1.$BUILD_ID pburela/$JOB_NAME:latest'
        }
       }

       stage('Push to docker hub'){
        steps{
             withCredentials([string(credentialsId: 'dockerhub_passwd', variable: 'dockerhub_passwd')]) 
                    {
                     sh 'docker login -u pburela -p ${dockerhub_passwd}'
                     sh  'docker image push pburela/$JOB_NAME:v1.$BUILD_ID'
                     sh  'docker image push pburela/$JOB_NAME:latest'
                   }
        }
       }
       
    }
}