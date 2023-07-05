pipeline{
    agent any
    tools { 
        maven 'maven' 
         
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

            def pomVersion = readMavenPom file: 'pom.xml'
            nexusArtifactUploader artifacts: [[
                artifactId: 'springboot', 
                classifier: '', 
                file: 'target/Uber.jar', 
                type: 'jar'
                ]], 
                credentialsId: 'nexus-auth', 
                groupId: 'com.example', 
                nexusUrl: '54.209.198.187:8081', 
                nexusVersion: 'nexus3', 
                protocol: 'http', 
                repository: 'demo-app-release', 
                version: "${pomVersion.version}"
        }
       }
       
    }
}