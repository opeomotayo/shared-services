pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh './mvnw clean package -Dcheckstyle.skip'
      }
    }
    stage('Generate SBOM') {
      steps {
        sh 'syft packages dir:. --scope AllLayers'
      }
    }
  }
}