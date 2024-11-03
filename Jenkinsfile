pipeline {
    agent { label 'Kmaster' }

    environment {
        DOCKER_IMAGE = "ashwathy/website-prt-org"
        KUBERNETES_NAMESPACE = "default"
        DEPLOYMENT_NAME = "website-deployment"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    // Checkout code from SCM
                    git url: 'https://github.com/tomboy98/Website-PRT-ORG.git', branch: 'main'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    docker.build(DOCKER_IMAGE)
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Push Docker image to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', '5a381bd4-e045-4fa4-9539-521918d69ea8') {
                        docker.image(DOCKER_IMAGE).push('latest')
                    }
                }
            }
        }
        stage('Deploying App to Kubernetes') {
            steps {
                script {
                    // Deploy application to Kubernetes
                    sh 'kubectl delete deploy prtwebsite'
                    sh 'kubectl delete svc website-service'
                    sh 'kubectl apply -f deploymentservice.yml'
                }
            }
        }
    }
}
