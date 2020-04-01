def COLOR_MAP = ['SUCCESS': 'good', 'FAILURE': 'danger', 'UNSTABLE': 'warning', 'ABORTED': '#C3BABF']

pipeline {
    agent { label 'master' }
    parameters {
        string(name: 'SERVICE',   defaultValue: 'express_gateway',   description: "Specify the GIT repo you want to build the image from")
        string(name: 'FORK',      defaultValue: 'Fidor-FZCO',   description: "Specify the fork of the GIT repository you would like to build from")
        string(name: 'BRANCH',    defaultValue: 'develop', description: "Specify the branch of the GIT repo to build the image from")
        string(name: 'NAMESPACE', defaultValue: 'foundation',   description: "Specify the namespace you want to push the image to")
        choice(
            name: 'REGISTRY',
            choices: ['030862835226.dkr.ecr.eu-west-1.amazonaws.com', 'dockerhub.fidorfzco.com:5000'],
            description: 'Specify the Docker Registry you want to push the image to'
        )
        booleanParam(name: 'Mergedbool', defaultValue: 'true', description: 'Check to build manually' )
    }
    
    stages {
       /*  Checkout the desired git branch */
        stage('Checkout SCM') {
        when {
            environment name: 'Mergedbool', value: 'true'
        }
        steps {
            checkout scm: [$class: 'GitSCM', branches: [[name: '${BRANCH}']], userRemoteConfigs: [[credentialsId: '68795a3a-52da-4d31-a0b5-84639e760a63', url: 'git@github.com:${FORK}/${SERVICE}.git']]]
        }
    }
        // /* Package the gems */
        // stage('Package the gems') {
        //     steps {
        //         sh '''#!/bin/bash -le
        //         BRANCH=$BRANCH make config
        //         '''
        //     }
        // }

        /* Build Docker container image */
        stage('Build the container image') {
            when {
                environment name: 'Mergedbool', value: 'true'
            }
            steps {
                sh '''#!/bin/bash -le
                NAMESPACE=$NAMESPACE BRANCH=$BRANCH make build
                '''
            }
        }

        /* Authenticates with Amazon ECR Repository and retrieves access token */
        stage("ECR Login") {
            when {
                environment name: 'Mergedbool', value: 'true'
            }
            steps {
                withAWS(credentials:'ecr') {
                    script {
                        def login = ecrLogin()
                        sh "${login}"
                    }
                }
            }
        }

        /* Push the build container image to the Docker registry */
        stage('Push the container image to the Docker registry') {
            when {
                environment name: 'Mergedbool', value: 'true'
            }
            steps {
                script {
                    sh 'NAMESPACE=$NAMESPACE BRANCH=$BRANCH make push'
                    sh 'make get_commit_hash > .git/commit-id'
                    env.GIT_COMMIT = readFile('.git/commit-id').trim()
                }
            }
        }
    }
    post {
        always {
            // Send notifications
            slackSend channel: '#jenkins-fidor_digital_platform',
            color: COLOR_MAP[currentBuild.currentResult],
            message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
            // clean up our workspace
            sh 'NAMESPACE=$NAMESPACE BRANCH=$BRANCH make clean'
            deleteDir()
        }
    }
}
