pipeline {
    agent any
    
    stages {
        stage('Build Agent') {
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

        stage('Deploy Agent') {
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