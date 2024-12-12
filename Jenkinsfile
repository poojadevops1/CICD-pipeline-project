pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = 'poojadevops1012'
        IMAGE_NAME = 'cicd-pipeline-node'
        IMAGE_TAG = "v${BUILD_NUMBER}"
        GITHUB_REPO_A = 'https://github.com/poojadevops1/CICD-pipeline-project'
        GITHUB_REPO_B = 'https://github.com/poojadevops1/ARGOCD-DEPLOY.git'  // Correct URL format for repo B
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh "docker build -t $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    echo "Pushing Docker image to Docker Hub..."
                    withDockerRegistry([credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/']) {
                        sh "docker push $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG"
                    }
                }
            }
        }
        stage('Update Manifest in Repo B') {
            steps {
                script {
                    echo "Cloning Repo B and updating deployment manifest..."
                    withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                        sh """
                        # Clone the GitHub repository using the token
                        git clone https://$GITHUB_TOKEN@github.com/$GITHUB_REPO_B.git repo-b
                        cd repo-b

                        # Update the image tag in the deployment manifest
                        sed -i 's|image:.*|image: $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG|' deployment.yaml

                        # Configure Git user details
                        git config user.email "pmanellore@gmail.com"
                        git config user.name "poojadevops1"

                        # Commit and push changes
                        git add deployment.yaml
                        git commit -m 'Updated image to $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG'
                        git push
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            echo "Cleaning up the workspace..."
            cleanWs()
        }
    }
}
