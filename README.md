# README
**Authors:** Austen Combs, Abanoub Farag, Nick Gaultney, Sebastian Prado

## Purpose
This web app is designed to interact with the QR codes placed around the CBU College of Engineering to provide a virtual tour of the building.

## Installation
* Install [Ruby v2.7](https://www.ruby-lang.org/en/)
* `git clone https://github.com/egr-401-402-capstone-2020-21/TEGR-Tours-App.git`
* Run `gem install bundler` within the directory associated with the git repository
* Run `bundle install` to download/install all ruby gems from `Gemfile` for dependencies

## Setting up the Database For Testing
* Run `rails db:migrate` to create Database
* Create a Rails Admin by running the following commands:
  - `rails c`
  - `User.create(:admin => true, :email => some_email@gmail.com', :password => 'abc123', :password_confirmation => 'abc123')`
* Database is initialized through Admin page on website
- Run `rails s -b 0.0.0.0 -p 80` and go to [localhost:80/admin](localhost:80/admin) ***NOTE: Mailer service runs on port 80 specifically, port 80 must be free for our website to send confirmation emails to users***
* Upload `EGR <Semester> Schedule`

## Testing
* Test on localhost by running `rails s -b 0.0.0.0 -p 80`
* QR Codes can be downloaded from [localhost:80/admin/download_qr_codes](localhost:80/admin/download_qr_codes)

## Deployment
- Clone Github Repo to computer
- To edit the docker files that build the docker image their paths are `/Dockerfile & /Dockerfile.nginx`
	* **There are two docker files one for the actual Site and a second that handles the frontend(Nginx)**
- To build the docker images type the following command: `docker build -f dockerfile/path -t <Dockername>/<tagname>`
	* **-f allows you to specify the docker file that will be used to build the image. -t allows you to specify the Docker account to add the image to and the name of the image.**
- To push docker image to docker hub repo type the following command: `docker push <Dockername>/<tagname>`
- Log into the AWS Console and go to Lightsail.
- Open the terminal associated to the TEGR-Site instance
- Enter the following command to edit the Docker Compose file: `nano docker-compose.yml`
	* **This file pulls the images that we created in step 3 & 4 and tells them how they will work together with the Postgres Database on the Lightsail Instance. Make sure the names used to build the docker images match the names used in the Compose file and are assigned to the right areas.**
- Before you deploy the new image or redeploy the old one clear out the old version of the site. Type the following three commands to remove the old docker images. 
```docker 
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker system prune -a
```
- Run the compose file and build the website by typing the following command: `docker-compose up`


## Submitting Code (Our Recomendation)
### 1. Create a Feature Branch
A developer creates the feature in a dedicated branch in their local repo using

`git checkout -b <featureName> <master>`

`<master>` represents the branch you are branching from.  This is typically the **master** branch.

You should only ever pull from **master** not write directly to it.  You can use `git branch` to confirm which branch you are on.

### 2. Push the Branch to Repo
The developer pushes to the repository by:
```git
git add .
git commit -m "your commit message here"
```
and when submitting code to your branch the first time

`git push -u origin featureName`

and `git push` for all subsequent times

### 3. Create a Pull Request
Developers file a [pull request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) via github.com or Git GUI.

### 4. Review and Edit
Teammates review code and confirm that it can be merged or request changes.  *This can be done through github.com if desired or through alternate communication means.*

### 5. Deploy to Master Branch
Once code has been reviewed it is merged typically through github.com or through `git --squash merge` and the featureBranch is closed.