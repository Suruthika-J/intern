pipeline {
    agent any

    environment {
        PATH = "C:\\Program Files\\nodejs;${env.PATH}"

        DEPLOY_DIR = "C:\\deploy\\toodoo"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo " Checking out code from GitHub repository..."
                git branch: 'main',
                    url: 'https://github.com/Karpagavalli-V/toodoo.git' 
            }
        }

        stage('Check Node & NPM Versions') {
            steps {
                echo " Checking Node.js and npm versions..."
                bat 'node -v'
                bat 'npm -v'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "Installing npm dependencies..."
                bat 'npm install'
            }
        }

        stage('Build React App (Vite)') {
            steps {
                echo "⚙ Building Vite React app..."
                bat 'npm run build'
            }
        }

        stage('Deploy Build Artifacts') {
            steps {
                echo "Deploying built files to deployment directory..."
                bat 'if not exist "%DEPLOY_DIR%" mkdir "%DEPLOY_DIR%"'
                
                bat 'xcopy dist "%DEPLOY_DIR%" /E /I /Y'
            }
        }
    }

    post {
        success {
            echo ' SUCCESS: Vite React app built and deployed successfully from "fromvalidator" pipeline!'
        }
        failure {
            echo 'ERROR: Build failed. Check Jenkins logs for detailed error output.'
        }
    }
}
