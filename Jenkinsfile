pipeline {
    environment {
        DOCKER_HOST = 'tcp://host.docker.internal:2375'
    }
    agent {
        docker {
            image 'radeczu/node-with-jq:terraform'
            args '--add-host=host.docker.internal:host-gateway -e DOCKER_HOST=tcp://host.docker.internal:2375'
        }
    }
    triggers {
      pollSCM '*/5 * * * *'
    }
    stages {

      stage('Prepare') {
        steps {
            cleanWs()
        }
      }

      stage('Authenticate') {
        steps {
          withCredentials([file(credentialsId: 'gcloud-sa-key', variable: 'GCP_KEY')]) {
            echo "Authenticating with GCP..."
            sh '''
              gcloud auth activate-service-account --key-file=$GCP_KEY
              gcloud config set project your-project-id
            '''
          }
        }
      }

      stage('Terraform') {
        steps {
            echo "Authenticating with GCP..."
        }
      }

      stage('Return Secrets') {
        steps {
            echo "Authenticating with GCP..."
        }
      }
      
    }
}