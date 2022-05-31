@ECHO OFF

SET dockerImage=zabroseric/sfdx-cli:latest
SET dockerLocation=C:\Program Files\Docker\Docker\Docker Desktop.exe

ECHO Detecting docker status...

IF NOT EXIST "%dockerLocation%" (
  ECHO Docker could not be found, please install it from the service catalogue, or using the link below:
  ECHO https://www.docker.com/products/docker-desktop/
  EXIT /b
)

docker ps > nul 2> nul
IF %errorlevel% NEQ 0 (
  ECHO Please start the Docker daemon and run the command again.
  EXIT /b
)

ECHO Environments detected:
docker container ls -a --format "- {{.Names}}"

:environmentPrompt
ECHO What is the name of the new/existing environment?
SET /p environment=""

IF "%environment%" == "" (
  ECHO An environment is required.
  GOTO environmentPrompt
)
set dockerName=%environment: =_%

@REM If the image could not be found, let's create one.
FOR /f %%i in ('docker container ls -aqf "name=^%environment%"') do set containerId=%%i
  IF "%containerId%" == "" (
    ECHO Pulling the latest image...
    docker pull %dockerImage% > nul

    ECHO Creating the container...
    docker run^
      -v %cd%:/project^
      -e ENVIRONMENT="%environment%"^
      --name "%dockerName%"^
      -it "%dockerImage%"^
      /bin/start.sh
    EXIT
  )
)

@REM Otherwise, let's just start the image.

ECHO Starting the container...
docker start %environment% > nul

ECHO Attaching to container...
docker exec^
  -e ENVIRONMENT="%environment%"^
  -it "%dockerName%"^
  /bin/start.sh