pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = credentials('DOCKER_REGISTRY') // Jenkins credentials ID for Docker Registry
        IMAGE_NAME = 'cicd-pipeline-node'               // Docker image name
        IMAGE_TAG = "v${BUILD_NUMBER}"                  // Unique tag for the build
        GITHUB_REPO_B = credentials('REPO_B')           // Jenkins credentials ID for Repo B URL
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh "docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo "Pushing Docker image to Docker Hub..."
                    withDockerRegistry([credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/']) {
                        sh "docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
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
                        git clone https://${GITHUB_TOKEN}@${GITHUB_REPO_B} repo-b
                        cd repo-b/manifest

                        # Update the image tag in the deployment manifest
                        sed -i 's|image:.*|image: ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}|' deployment.yaml

                        # Configure Git user details
                        git config user.email "pmanellore@gmail.com"
                        git config user.name "poojadevops1"

                        # Commit and push changes
                        git add deployment.yaml
                        git commit -m 'Updated image to ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}'
                        git push origin main
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
                        git clone https://${GITHUB_TOKEN}@${GITHUB_REPO_B} repo-b
                        cd repo-b/manifest

                        # Update the image tag in the deployment manifest
                        sed -i 's|image:.*|image: $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG|' deployment.yaml

                        # Configure Git user details
                        git config user.email "pmanellore@gmail.com"
                        git config user.name "poojadevops1"

                        # Commit and push changes
                        git add deployment.yaml
                        git commit -m 'Updated image to $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG'
                        git push origin main
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

