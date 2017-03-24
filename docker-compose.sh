#!/bin/bash

MAXRETRY=10

function waitFor() {
  WAITTIME=1
  RETVAL=-1
  RETRY=1
  while [[ $RETVAL -ne 0 && $RETRY -le $MAXRETRY ]]; do
    curl $1 >/dev/null 2>&1
    RETVAL=$?
    case $RETVAL in
      0) return;;
      *) if [[ $WAITTIME -eq 1 ]]; then
           echo "Waiting 1 Second"
         else
           echo "Waiting $WAITTIME Seconds"
         fi
         sleep $WAITTIME
         WAITTIME=$(expr $WAITTIME + $WAITTIME)
         RETRY=$(expr $RETRY + 1);;
    esac
  done
  echo "max Wait Retries of $MAXRETRY reached -> Shutting down"
  docker-compose down
  exit 1
}

function showUsage() {
  echo "Usage: $(basename $0) [-?|-h] [-r]"
  echo "Options:"
  echo "  -? | -h ... Shows this Help Screen"
  echo "  -r      ... Restart this Application"
  echo "  -c      ... maximum Connection Retries (Default: $MAXRETRY)"
}

unset RESTART
while getopts ":hrc:" opt; do
  case $opt in
    \?) if [[ $OPTARG != "?" ]]; then
          echo "Invalid Option -$OPTARG" >&2
          showUsage
          exit 1
        fi
        showUsage
        exit 0;;
     h) showUsage
        exit 0;;
     r) RESTART=true;;
     c) MAXRETRY=$OPTARG;;
  esac
done
shift $((OPTIND-1))

if [[ $RESTART ]]; then
  echo "Shutting down Docker Containers"
  docker-compose down
fi

echo "Starting Configserver"
docker-compose up -d configserver
waitFor localhost:8888

echo "Starting Eureka"
docker-compose up -d eureka
waitFor localhost:8761

echo "Starting Turbine"
docker-compose up -d turbine
waitFor localhost:8080

echo "Application is ready to be used"
echo "Try curl localhost:8080/hint"
