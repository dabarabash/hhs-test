#!/bin/bash
git -C ~ clone https://github.com/hhstechgroup/sample-application
cd ~/sample-application
./gradlew clean bootJar
./gradlew test
cd ~/sample-application/build/libs
echo -e "FROM openjdk:jre\nMAINTAINER dmitriy_barabash\nWORKDIR ~/sample-application/build/libs\nCOPY sample-application-0.0.1-SNAPSHOT.jar ~/$
docker build -t samp_app_img .
docker run -d -p 8883:8883 samp_app_img
while [ -n TRUE ]; do
    STATUS_CODE=`curl -Is http://localhost:8883/sample/tests | head -n1 | awk '{print($2)}'`
    if [ -n "$STATUS_CODE" ]; then
         echo "Site is up :)"
break
    fi

    if [ -z "$STATUS" ]; then
         echo "Site is down :("
    fi
    sleep 3
done
stop=`docker ps | grep 'samp_app_img' | awk ' { print $1 } ' | xargs docker stop`
echo 'Enter your docker-account login'
read login
docker login -u "$login"
docker tag samp_app_img "$login"/samp_app_img
docker push "$login"/samp_app_img
echo "Check your Docker repo"
