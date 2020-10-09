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
         stage('Deploying') {
              steps{
                  echo 'Deploying to AWS...'
                  withAWS(credentials: 'AWSCred', region: 'us-west-2') {
                     sh "aws eks --region us-west-2 update-kubeconfig --name my-cluster"
                     sh "kubectl config use-context arn:aws:eks:us-west-2:874698838459:cluster/my-cluster"
                     sh "kubectl apply -f webserver.yml"
                  }
              }
        }
    }
}
