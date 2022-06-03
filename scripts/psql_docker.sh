#!/bin/bash
# used to capture the CLI arguments when we run the script
cmd=$1
db_username=$2
db_password=$3
# we are checking if docker is running if its not start docker
sudo systemctl status docker || sudo systemctl start docker
#assing the status of the container to see if its running
docker container inspect jrvs-psql
container_status=$?
export PGPASSWORD=$db_password

case $cmd in
  #create container
  create)
  if [ "$container_status" -eq 0 ]
    then
    echo "Container already exists"
    exit 1
  fi
  #checking if user has 3 arguments in cli
  if [ $# -ne 3 ]
    then
    echo 'Create requires username and password'
    exit 1
  fi
  #pull postgres from docker
  #docker pull postgres
  docker volume create pgdata
  # creating docker container with db_user and db_password using postgres 9.6-alpine
  docker run --name jrvs-psql -e POSTGRES_USER="${db_username}" -e POSTGRES_PASSWORD="${db_password}" -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine
  docker container ls -a -f name=jrvs-psql
  docker ps -f name=jrvs-psql
  exit 0
  ;;
  #start or stop the container
  start|stop)
    if [ "$container_status" -ne 0 ]
    then
      echo "docker is not running"
      exit 1
    fi
    docker container "$cmd" jrvs-psql
    exit 0
    ;;
  *)
    echo "illegal command"
    echo "Commands: start|stop|create"
    exit 1
    ;;
  esac
