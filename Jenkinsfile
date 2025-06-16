pipeline {
    environment {
        DOCKER_HOST = 'tcp://host.docker.internal:2375'
        CLOUDSDK_CONFIG = "${WORKSPACE}/.gcloud"
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
            
            sh '''

            rm -f .env
            mkdir -p $CLOUDSDK_CONFIG
            
            '''
        }
      }

      stage('Authenticate') {
        steps {
          withCredentials([file(credentialsId: 'gcloud-sa-key', variable: 'GCP_KEY')]) {
            echo "Authenticating with GCP..."
            sh '''
              echo $HOME
              gcloud auth activate-service-account --key-file=$GCP_KEY
              gcloud config set project devopstraining-459716
            '''
          }
        }
      }

      stage('Fetch Secrets') {
          steps {
            sh '''
              echo "Fetching secrets from Google Secret Manager..."

              echo TF_VAR_DOCKER_USERNAME=$(gcloud secrets versions access latest --secret="docker-username") >> .env
              echo TF_VAR_GITHUB_PAT=$(gcloud secrets versions access latest --secret="dockerhub-pat") >> .env
              echo TF_VAR_FRUITS_ROOT_PASS=$(gcloud secrets versions access latest --secret="fruits-root-pass") >> .env
              echo TF_SA_EMAIL=$(gcloud secrets versions access latest --secret="terraform-sa-email") >> .env

            '''
          }
      }

      stage('Terraform') {
        steps {
            withCredentials([file(credentialsId: 'gcloud-sa-key', variable: 'GCP_KEY')]) {
              echo "Running Terraform..."
              sh '''

                gcloud auth activate-service-account --key-file="$GCP_KEY"
                gcloud config set project devopstraining-459716
                export GOOGLE_APPLICATION_CREDENTIALS="$GCP_KEY"

                while IFS='=' read -r key value; do

                  #skip comments
                  if [[ -z "$key" || "$key" =~ ^# ]]; then
                    continue
                  fi

                  key=$(echo "$key" | xargs)
                  value=$(echo "$value" | xargs)

                  export "$key=$value"
                done < .env
                echo "--- Environment variables set from .env ---"
                gcloud auth print-access-token --impersonate-service-account=$TF_SA_EMAIL > tf-access-token.txt
                export TF_SA_ACCESS_TOKEN=$(cat tf-access-token.txt)

                terraform init
                terraform validate
                terraform plan -out=tfplan
                terraform apply -auto-approve tfplan
              '''
            }
        }
      }

      stage('Return Secrets') {
        steps {
            echo "Returning secrets..."
        }
      }
      
    }
}