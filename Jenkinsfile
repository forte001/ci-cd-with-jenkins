node {

	def my_app

	stage('Clone Repository') {

		checkout scm
	}


	stage('Build image'){

		my_app = docker build('040803323661.dkr.ecr.us-west-2.amazonaws.com/my_app')


	}

	stage('Push image'){

		docker.withRegistry('https://040803323661.dkr.ecr.us-west-2.amazonaws.com/', 'ecr:us-west-2:my-aws-credentials') {
			
			my_app.push("${env.BRANCH_NAME}-${env.BUILD_NUMBER}")
			my_app.push("latest")
		}

	}


}