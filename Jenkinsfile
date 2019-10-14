pipeline {
  agent {
    docker {
      image 'cirrusci/flutter'
    }

  }
  stages {
    stage('Build') {
      steps {
        sh 'flutter build apk --split-per-abi'
      }
    }
    stage('Deploy') {
      steps {
        archiveArtifacts 'build/app/outputs/apk/release/app-armeabi-v7a-release.apk'
        archiveArtifacts 'build/app/outputs/apk/release/app-arm64-v8a-release.apk'
      }
    }
  }
}