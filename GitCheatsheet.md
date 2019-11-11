# Git cheatsheet

>`git config --global user.name "James' MacBook Pro"`\
>`git config --global user.email "joliver.robert@me.com"`\
>`ssh-keygen -t rsa -b 4096 -C "Git Key"`\
>{PassPhrase = “Snowy”}\
>`ssh -T git@github.com` #Tests ssh connection\
>`eval $(ssh-agent)` # Starts ssh-agent\
>`ssh-add -K`  # Add passphrase to Key chain 

>`git clone <repo>`

>`git branch "First-Branch"`\
>`get checkout "First-Branch"`\
>`git checkout -b hotfix` (Checkouts and creates new branch)\
>`git add readme.md`\
>`git status`\
>`git commit -m` "This is a test of commiting in Git."
>#`git commit -a -m "This is a test of commiting in Git."` (Adds all changed documents to staging)
>`git checkout master`
>`Git merge First-Branch`
>`Git branch -d First-Branch` (-d requires push to origin first, -D deletes regardless.
>`Git push origin`

>`git branch -a` (Shows all branches including remote)

>`git pull --all`
>`git branch --set-upstream-to=origin/<branch> <branch>`

## Guides 

Brilliant guide: https://dont-be-afraid-to-commit.readthedocs.io/en/latest/git/commandlinegit.html

Another great guide: https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging

Another brilliant guide: https://www.dataschool.io/simple-guide-to-forks-in-github-and-git/