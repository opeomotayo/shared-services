pipeline {
  agent any
  stages {
    stage('Delete image if exists') {
      steps {
        sh 'docker rmi java-docker:latest'
      }
    }
    stage('Create container image') {
      steps {
        sh 'docker build --tag java-docker:latest .'
      }
    }
    stage('Generate SBOM') {
      steps {
        sh 'syft packages java-docker:latest --scope AllLayers'
      }
    }
  }
}