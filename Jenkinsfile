node {

	def my_app

	stage('Clone Repository') {

		checkout scm
	}


	stage('Build image'){

		my_app = docker.build('040803323661.dkr.ecr.us-west-2.amazonaws.com/my_app')


	}

	stage('Push image'){

		docker.withRegistry('https://040803323661.dkr.ecr.us-west-2.amazonaws.com/', 'ecr:us-west-2:my-aws-credentials') {
			
			my_app.push("my-test-app-${env.BUILD_NUMBER}")
			my_app.push("latest")
		}

	}


	stage('Deploy'){

		sh " docker run --name test-app -d -p 8081:80 040803323661.dkr.ecr.us-west-2.amazonaws.com/my_app:latest "
	}


}