#!/bin/bash
## obtaining code
git -C ~ clone https://github.com/hhstechgroup/sample-application
cd ~/sample-application
## executing build application
./gradlew clean bootJar
## run tests
./gradlew test
## making Dockerfile
echo -e "FROM openjdk:jre\nMAINTAINER dmitriy_barabash\nCOPY ./build/libs/sample-application-0.0.1-SNAPSHOT.jar sample-application-0.0.1-SNAPSHOT.jar\nEXPOSE 8883\nCMD [\"java\",\"-jar\",\"sample-application-0.0.1-SNAPSHOT.jar\"]" > Dockerfile
## build Docker image
docker build -t samp_app_img .
## running build image
docker run -d -p 8883:8883 samp_app_img
## waiting for website uptime
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
## stopping image
stop=`docker ps | grep 'samp_app_img' | awk ' { print $1 } ' | xargs docker stop`
## naming Docker image
docker tag samp_app_img dbarabash/samp_app_img
## Pushing image to docker hub
docker push dbarabash/samp_app_img
echo "Now you may check your pushed image on Docker hub"
rm -rf ~/sample-application
docker images | grep 'none' | awk ' {print $3} ' | xargs docker rmi -f &> /dev/null
