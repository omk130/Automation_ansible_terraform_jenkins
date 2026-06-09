pipeline {
    agent any

    environment {
        TF_DIR = "terraform"
        ANSIBLE_DIR = "ansible"
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
}
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/omk130/Automation_ansible_terraform_jenkins.git'
            }
        }

        stage('Test Terraform') {
            steps {
                bat 'terraform -version'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    bat 'terraform init"'
                }
            }
        }

       stage('Terraform Apply') {
            steps {
        withCredentials([
            string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
            string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
            dir("${TF_DIR}") {
                bat 'terraform apply --auto-approve'
            }
        }
    }
}

        stage('Get Terraform Output') {
            steps {
                script {
                    def ip = bat(
                        script: "terraform -chdir=${TF_DIR} output -raw public_ip",
                        returnStdout: true
                    ).trim()

                    env.SERVER_IP = ip
                    echo "Server IP: ${env.SERVER_IP}"
                }
            }
        }

        stage('Create Ansible Inventory') {
            steps {
                bat """
                echo [web] > ansible\\inventory.ini
                echo ${env.SERVER_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/omkar/.ssh/ansible-lab.pem >> ansible\\inventory.ini
                """
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                bat "wsl ansible-playbook -i ansible/inventory.ini ansible/playbook.yml"
            }
        }

        stage('Completed') {
            steps {
                echo "Infrastructure deployed and configured successfully!"
            }
        }
    }
}