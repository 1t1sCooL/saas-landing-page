pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = '1t1scool' 
        IMAGE_NAME = 'saas-landing-page'
        IMAGE_TAG = "${BUILD_NUMBER}"
        FULL_IMAGE = "${DOCKER_HUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
        DOCKER_HUB_CREDS = 'dockerhub'
        LATEST_IMAGE = "${DOCKER_USER}/${IMAGE_NAME}:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_HUB_CREDS}", 
                                 usernameVariable: 'USER', 
                                 passwordVariable: 'PASS')]) {
                    sh """
                        echo "🐳 Building Docker image..."
                        docker build -t ${FULL_IMAGE} -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest .

                        echo "🔑 Logging into Docker Hub..."
                        echo \$PASS | docker login -u \$USER --password-stdin

                        echo "📤 Pushing image..."
                        docker push ${FULL_IMAGE}
                        docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Update image in manifests') {
            steps {
                sh """
                    echo "📝 Updating image in kubernetes manifests..."
                    # Теперь sed ищет ваш Docker Hub путь
                    sed -i "s|image: .*${IMAGE_NAME}.*|image: ${FULL_IMAGE}|g" kubernetes/deployment.yaml
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    echo "🚀 Applying kubernetes manifests..."
                    # Убедитесь, что у Jenkins есть доступ к конфигу k3s (/var/lib/jenkins/.kube/config)
                    kubectl apply -k kubernetes/
                """
            }
        }
    }
    
    post {
        always {
            sh "docker logout" 
            sh "docker rmi ${FULL_IMAGE} ${LATEST_IMAGE} || true"
        }
    }
}