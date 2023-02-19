pipeline{
    agent any

    tools{
        maven "maven"
        jdk "java"
    }
    environment{
        dockerAcc='shivamj2ee'
        appName='springbootapp'
    }
    stages{
        stage('gitpull') {
            steps {
                git 'https://github.com/shivam-j2ee/SpringBootProject.git'
                
            }
        }
        stage('clean') {
            steps {
               sh 'mvn clean'
               sh 'mvn install -Dmaven.test.skip=true'
               
            }
        }
        stage('build') {
            steps {
                 sh 'mvn package -Dmaven.test.skip=true'
            }
        }
        stage('build image') {
            steps {
                 sh "docker build -t ${dockerAcc}/${appName}:${BUILD_NUMBER} ."
            }
        }
        stage('push image') {
            steps {
                withCredentials([string(credentialsId: 'ddeb48f3-3b43-40f8-9571-3bd00b5dfa10', variable: 'dockercredential')]) {
                    sh "docker login -u ${dockerAcc} -p ${dockercredential}"
                }
                
                sh "docker push ${dockerAcc}/${appName}:${BUILD_NUMBER}"
            }
        }
        stage('Deploy') {
            steps {
	            	sh "docker run -itd -p 8181:8080 --name springApp ${dockerAcc}/${appName}:${BUILD_NUMBER}"
            }     	
        }
    }
}
