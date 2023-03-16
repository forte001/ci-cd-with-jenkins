node {

	def my_app

	stage('Clone Repository') {

		checkout scm
	}


	stage('Build image'){

		my_app = docker build('forte/my_app')


	}

	stage('Push image'){

		docker.withRegistry('Registry name', 'registry credentials') {
			my_app.push('latest')
		}

	}
}