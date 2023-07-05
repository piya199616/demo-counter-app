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
            withSonarQubeEnv(credentialsId: 'sonar-api') {
                sh 'mvn clean package sonar:sonar'
              }
        }
       }
       
    }
}