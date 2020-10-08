pipeline {
    agent any
    stages {
        stage('Lint HTML') {
            steps {
                sh 'tidy -q -e project/*.html'
            }
        }
        stage('Build Docker Image') {
            steps {
                echo '=== Building Docker Image ==='
                script {
                    app = docker.build("khaledgamalelsayed/webserver")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                echo '=== Pushing Docker Image ==='
                script {
                    GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    SHORT_COMMIT = "${GIT_COMMIT_HASH[0..7]}"
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerCred') {
                        app.push("$SHORT_COMMIT")
                        app.push("latest")
                    }
                }
            }
        }
        stage('Remove local images') {
            steps {
                echo '=== Delete the local docker images ==='
                sh("docker rmi -f khaledgamalelsayed/webserver")
            }
        }
        stage('AWS Credentials') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWSCred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                sh """  
                    mkdir -p ~/.aws
                    echo "[default]" >~/.aws/credentials
                    echo "[default]" >~/.boto
                    echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >>~/.boto
                    echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}">>~/.boto
                    echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >>~/.aws/credentials
                    echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}">>~/.aws/credentials
                """
                }
            }
        }
        stage('deploy images') {
            stage('Run maven') {
                agent {
                    kubernetes {
                        yamlFile webserver.yaml
                    }
                }
            }
        }
    }
}
