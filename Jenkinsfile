// test github hook
pipeline {
	agent any

	stages {

		stage("build") {
			steps {
				echo 'Building the docker image'
				docker.withRegistry('https://${env.docker-repository-host}:${env.docker-repository-port}') {
					def customImage = docker.build("covid-builder:${env.BUILD_ID}")
					
				}
			}
		}

		stage("deploy") {
			steps {
				echo 'deploying the application'
			}
		}
	}
}