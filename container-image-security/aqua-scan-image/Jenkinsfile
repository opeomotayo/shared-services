pipeline {
  agent any
  environment {
    AQUA_ROOT_DIR="$WORKSPACE/.aqua"
    PATH="$WORKSPACE/.aqua/bin:$PATH"
  }
  stages {
    stage('Verify aqua installation') {
      steps {
        sh 'aqua version'
        sh 'which aqua'
      }
    }
    stage('Install aqua packages') {
      steps {
        sh 'aqua i'
      }
    }
    stage('Verify aqua packages') {
      steps {
        sh 'command -v jq'
        sh 'jq --version'
      }
    }
  }
}
