def COLOR_MAP = ['SUCCESS': 'good', 'FAILURE': 'danger', 'UNSTABLE': 'warning', 'ABORTED': '#C3BABF']

pipeline {
    agent { label 'master' }
    parameters {
        string(name: 'Mergedbool', defaultValue: 'true', description: 'Set this to true if this is a manual build' )
        string(name: 'FORK',      defaultValue: 'Fidor-FZCO', description: "Fork  of the git repository")
        string(name: 'BRANCH',   defaultValue: 'develop', description: "Branch to build")
        string(name: 'REGISTRY', defaultValue: 'dockerhub.fidorfzco.com:5000',     description: 'Namespace for the Docker Image')
        string(name: 'NAMESPACE',   defaultValue: 'foundation', description: "Namespace for the Docker Image")
        string(name: 'SERVICE', defaultValue: 'express-gateway',     description: 'Namespace for the Docker Image')
    }
    stages {
       /*  Checkout the desired git branch */
        stage('Checkout SCM') {
        when {
            environment name: 'Mergedbool', value: 'true'
        }
        steps {
            checkout scm: [$class: 'GitSCM', branches: [[name: '${BRANCH}']], userRemoteConfigs: [[credentialsId: '68795a3a-52da-4d31-a0b5-84639e760a63', url: 'git@github.com:${FORK}/express_gateway.git']]]
        }
    }
        /* Package the gems * /
        stage('Package the gems') {
            steps {
                sh '''#!/bin/bash -le
                BRANCH=$BRANCH make config
                '''
            }
        }

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
            // clean up our workspace
            echo 'I will always say Hello again!'
            slackSend channel: '#jenkins-foundation',
                color: COLOR_MAP[currentBuild.currentResult],
                message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"

            sh 'NAMESPACE=$NAMESPACE BRANCH=$BRANCH make clean'
            deleteDir()
        }
    }
}
