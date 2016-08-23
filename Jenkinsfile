node ('virtualbox') {
  def directory = "ansible-role-rabbitmq"
  env.ANSIBLE_VAULT_PASSWORD_FILE = "~/.ansible_vault_key"
  stage 'Clean up'
  deleteDir()

  stage 'Checkout'
  sh "mkdir $directory"
  dir("$directory") {
    checkout scm
  }
  dir("$directory") {
    stage 'bundle'
    sh 'bundle install --path vendor/bundle'

    stage 'bundle exec kitchen test'
    try {
      sh 'bundle exec kitchen test'
    } finally {
      sh 'bundle exec kitchen destroy'
    }
/* comment out if you have integration tests
    stage 'integration'
    try {
      // use native rake instead of bundle exec rake
      // https://github.com/docker-library/ruby/issues/73
      sh 'rake TEST_TASK
    } finally {
      sh 'rake CLEANUP_TASK'
    }
*/
    stage 'Notify'
    step([$class: 'GitHubCommitNotifier', resultOnFailure: 'FAILURE'])
  }
}
