pipeline {
  agent any

  parameters {
    choice(name: 'ACTION', choices: ['plan', 'apply','destroy'], description: 'Choose whether to plan or apply Terraform changes')
    choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select the Terraform variable file to use')
  }

  environment {
    TF_DIR = 'ec2'
    AWS_DEFAULT_REGION = 'ap-south-2'
    TF_IN_AUTOMATION = 'true'
    TF_CLI_ARGS = '-no-color'
  }

  stages {
    stage('clean ws') {
      steps {
        cleanWs()
      }
    }
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
          dir("${TF_DIR}") {
            sh 'terraform init -input=false'
          }
        }
      }
    }

    stage('Terraform Validate') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
          dir("${TF_DIR}") {
            sh 'terraform validate'
          }
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
          dir("${TF_DIR}") {
            sh "terraform plan -input=false -var-file=terraform.${params.ENV}.tfvars -out=tfplan"
          }
        }
      }
    }

    stage('Terraform Apply') {
      when {
        expression { params.ACTION == 'apply' }
      }
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
          dir("${TF_DIR}") {
            sh 'terraform apply -auto-approve -input=false tfplan'
          }
        }
      }
    }

        stage('Terraform Destroy Plan') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    dir("${TF_DIR}") {
                        sh "terraform plan -destroy -var-file=terraform.${params.ENV}.tfvars -out=tfplan"
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    dir("${TF_DIR}") {
                        sh 'terraform apply -auto-approve -input=false tfplan'
                    }
                }
            }
        }
  }

  post {
    always {
      dir("${TF_DIR}") {
        sh 'rm -f tfplan || true'
      }
    }
  }
}
