pipeline {
    agent any

    environment {
        TF_DIR = "terraform"
        ANSIBLE_DIR = "ansible"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/omk130/Automation_ansible_terraform_jenkins'
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'wsl bash -lc "cd terraform && terraform init"'
            }
        }

        stage('Terraform Apply') {
            steps {
                bat 'wsl bash -lc "cd terraform && terraform apply -auto-approve"'
            }
        }

        stage('Get Terraform Output') {
            steps {
                script {
                    def ip = bat(
                        script: 'wsl bash -lc "cd terraform && terraform output -raw public_ip"',
                        returnStdout: true
                    ).trim().split("\\r?\\n")[-1]

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
                bat 'wsl bash -lc "cd ansible && ansible-playbook -i inventory.ini playbook.yml"'
            }
        }

        stage('Completed') {
            steps {
                echo "Infrastructure deployed and configured successfully!"
            }
        }
    }
}