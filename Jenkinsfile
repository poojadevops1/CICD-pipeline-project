pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = 'poojadevops1012'
        IMAGE_NAME = 'cicd-pipeline-node'
        IMAGE_TAG = "v${BUILD_NUMBER}"
        GITHUB_REPO_A = 'https://github.com/poojadevops1/CICD-pipeline-project'
        GITHUB_REPO_B = 'poojadevops1/ARGOCD-DEPLOY'
        GITHUB_TOKEN = credentials('github-token') // GitHub token stored in Jenkins credentials
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/']) {
                        sh "docker push $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG"
                    }
                }
            }
        }
        stage('Update Manifest in Repo B') {
            steps {
                script {
                    // Cloning the repository with GitHub token in the URL
                    sh """
                    git clone https://$GITHUB_TOKEN@github.com/$GITHUB_REPO_B.git repo-b || exit 1
                    cd repo-b
                    
                    // Updating the image tag in the deployment.yaml file
                    sed -i 's|image:.*|image: $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG|' deployment.yaml
                    
                    // Commit the changes and push to the remote repository
                    git add deployment.yaml
                    git commit -m 'Updated image to $DOCKER_REGISTRY/$IMAGE_NAME:$IMAGE_TAG'
                    git push origin main || exit 1
                    """
                }
            }
        }
    }
    post {
        always {
            cleanWs() // Cleaning workspace after the pipeline execution
        }
    }
}
