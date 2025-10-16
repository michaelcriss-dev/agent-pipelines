pipeline {
    agent any
    
    stages {
        stage('Build CI') {
            steps {
                script {
                    def ciPipeline = 'Build-Agent'
                    echo "Disparando Build Agent: ${ciPipeline}"
                    build job: ciPipeline,
                          parameters: [
                            string(name: 'BRANCH', value: ' agent-pipelines'),
                            string(name: 'BUILD_NUMBER_PARENT', value: "${BUILD_NUMBER}")
                          ],
                          wait: true
                }
            }
        }

        stage('QA infraestructure') {
            steps {
                script {
                    def qaPipeline = 'Deploy-Agent'
                    echo "Disparando Deploy Agent: ${qaPipeline}"
                    build job: qaPipeline,
                          parameters: [
                            string(name: 'BRANCH', value: 'agent-pipelines'),
                            string(name: 'BUILD_NUMBER_PARENT', value: "${BUILD_NUMBER}")
                          ],
                          wait: true
                }
            }
        }
    }
}