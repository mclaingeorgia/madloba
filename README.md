# Sheaghe
Sheaghe is an app for MAC Georgia to show which disability services are available in the country of Georgia.

The app was original based off of the [Madloba app](https://github.com/etiennebaque/madloba), but has since been updated numerous times.

# Getting Started

## Prerequisites
- Git
- rbenv
- Ruby 2.3.5
- Bundler
- Postgres 9

## Installing
- clone the repo
- run `bundle install`

## Set Environment Variables
Environment variables are used to set the database credentials, secret key, etc. A template can be found at `/config/app_environment_variables.rb.sample`. Create a copy and populate it as nedded at `/config/app_environment_variables.rb`.

NOTE - most keys that start with `MADLOBA` are no longer being used.

## Create database
Run the following commands to setup and populate the database
```
bundle exec rake db:setup
bundle exec rake uploader_v2:import_data
```

## Run the app

```
rails s
```

# Deploying
The application uses capistrano for deployment so the process of deployment is pretty painless. However, there are some important steps to know about.

## Setup server
Before deploying, the server must be setup properly.
- Git
- rbenv
- Ruby 2.3.5
- [rbenv-vars](https://github.com/rbenv/rbenv-vars) - this is enter enviornment variable values into the app
- Bundler
- Postgres 9
    - You will need to create a postgres user that will have access to the app database
- Nginx

## Setup deploy files

There is a sample deploy file at `/config/deploy.rb.sample` - copy and populate it as necessary at `/config/deploy.rb`

In the `config/deploy` folder there is a sample environment deploy config file for production and staging. Copy the appropriate sample file and populate as needed at `/config/deploy/production.rb` or `/config/deploy/staging.rb`

## Initial setup
Unfortunatley, since the app was copied from the Madloba app, there are some items that have to be done by hand. The following commands assume you are deploying to production. If you are not, simply replace 'production' with 'staging'.
- `cap production setup` - this will do the following:
    - create app directory
    - create shared and shared/config directory
    - install nginx config
    - install unicorn config
    - make unicorn start on server start
    - setup logrotate
- Manually create a few files on the server
    - `shared/config/database.yml` - copy the content from the local repo at `/config/database.yml' for the appropiate environment
    - `shared/config/secrets.yml` - copy the content from the local repo at `/config/secrets.yml' for the appropiate environment
    - `shared/.rbenv-vars` - copy the content from the local repo at `/config/app_environment_variables.rb'; remove the ENV[] and just keep the variables names; database credentials are not need since they are in the database.yml file
- `cap production unicorn:setup_app_config` - this will automatically copy the unicorn.rb file from `/config/deploy/templates/unicorn.rb.erb` to the server

## Deploy
```
cap production deploy
```
