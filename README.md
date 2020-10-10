capstone-project-cloud-devops

This project is a final step for my devops nanodegrees.

Project Steps: 
1- install jenkins in aws ec2 machine
2- deploy aws eks cluster
3- confinger jenkins pipline to do the following
   a) Lint your html 
   b) build and push docker image
   b) performs the correct steps to do a rolling deployment

Notes 
- to start kubernetes cluster you can follow the getting-started-eksctl to user cloudFormation stacks to speedup the process. https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html

- the project takes a Dockerfile and creates a Docker container in the pipeline. in one jenkins steps it will update the image in the deployment and then it will apply the deplyoment.

- this project is using rolling update strategy in kubernetes and the configuration is in the deployment file, along aside with loadBalancer service