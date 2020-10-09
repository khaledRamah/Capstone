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
                echo env.BuildNo
                script {
                    env.BuildNo = 1
                    app = docker.build("khaledgamalelsayed/webserver:" + env.BuildNo)
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
                        app.push(env.BuildNo)
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
                     sh "aws eks --region us-west-2 update-kubeconfig --name eks-cluster"
                     sh "kubectl config use-context arn:aws:eks:us-west-2:874698838459:cluster/eks-cluster"
                     sh "kubectl set image deployments/webserver-deployment webserver=khaledgamalelsayed/webserver:" + env.BuildNo
                     sh "kubectl apply -f webserver.yml"
                     sh "kubectl apply -f webservice.yml"
                  }
              }
        }
    }
}
