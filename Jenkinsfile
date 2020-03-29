pipeline {
    agent {
        label "master"
    }
    environment {
        LOCAL_WORKTREE = "/home/oleg/src/nixpkgs"
        MASTER_WORKTREE = "${LOCAL_WORKTREE}-master"
        GIT_PULL_COMMAND = "git pull --rebase upstream master"
    }
    triggers {
        cron("H 15 * * 1-5")
    }
    stages {
        stage("Pulling from upstream Git") {
            steps {
                dir(LOCAL_WORKTREE) {
                    sh GIT_PULL_COMMAND
                }
                dir(MASTER_WORKTREE) {
                    sh GIT_PULL_COMMAND
                }
            }
        }
        stage("Cloning from local Git") {
            steps {
                parallelGitClone url: "https://cgit.duckdns.org/git/nix/nixpkgs",
                branch: "wip-local",
                nodeLabels: ["guix", "guix nixbld", "guix vm"],
                dir: LOCAL_WORKTREE
            }
        }
    }
    post {
        always {
            sendNotifications currentBuild.result
        }
    }
}
