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
                dir("${TF_DIR}") {
                    bat 'wsl bash -lc "cd terraform && terraform init"'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                    bat 'wsl terraform apply --auto-approve'
                }
            }
        }

        stage('Get Terraform Output') {
            steps {
                script {
                    def ip = bat(
                        script: "wsl terraform -chdir=${TF_DIR} output -raw public_ip",
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