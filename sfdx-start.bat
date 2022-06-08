@ECHO OFF
setlocal EnableExtensions EnableDelayedExpansion

CALL :setESC
CLS

ECHO %ESC%[32m========================================%ESC%[0m
ECHO %ESC%[32m        SFDX Container Builder          %ESC%[0m
ECHO %ESC%[32m========================================%ESC%[0m

SET dockerImage=zabroseric/sfdx-cli:latest
SET dockerLocation=C:\Program Files\Docker\Docker\Docker Desktop.exe

@REM =====================================================
@REM Docker Check Logic
@REM =====================================================
:dockerCheckStart
ECHO Detecting docker status...
IF NOT EXIST "%dockerLocation%" (
  ECHO %ESC%[31mDocker could not be found, please install it from the service catalogue, or using the link below:%ESC%[0m
  ECHO https://www.docker.com/products/docker-desktop/
  EXIT /b
)

docker ps > nul 2> nul
IF %errorlevel% NEQ 0 (
  ECHO %ESC%[31mPlease start the Docker daemon and run the command again.%ESC%[0m
  EXIT /b
)


@REM =====================================================
@REM Existing Container Logic
@REM =====================================================
:existingContainerStart
ECHO Environments detected:
SET i=0
FOR /F "tokens=*" %%a in ('docker container ls -a --format "{{.Names}}"') DO (
    SET /A i+=1
    ECHO !i!^) %%a
)

@REM If no containers are found go to creation.
IF %i% == 0 (
  ECHO %ESC%[33mNo environments detected%ESC%[0m
  GOTO newContainerStart
)

:environmentPrompt
ECHO What environment do you want to use ^(leave blank to create a new one^)?
SET /p environmentNumber=""


@REM If blank, the user has chosen to create one.
IF "%environmentNumber%" == "" (
  ECHO Creating new container...
  GOTO newContainerStart
)

set /a environmentNumberInt=%environmentNumber%
if %environmentNumberInt% NEQ %environmentNumber% (
  ECHO %ESC%[31mPlease enter the number corresponding to the environment%ESC%[0m
  SET environmentNumber=
  GOTO environmentPrompt
)


@REM Try to find the number in the list of containers.
SET i=0
FOR /F "tokens=*" %%a in ('docker container ls -a --format "{{.Names}}"') DO (
    SET /A i+=1
    IF "!i!" == "%environmentNumber%" (
      SET environmentExisting=%%a
    )
)

@REM If we found the number, start the container.
IF "%environmentExisting%" NEQ "" (
  ECHO Starting the container...
  docker start "%environmentExisting%" > nul

  ECHO Attaching to container...
  docker exec^
    -e ENVIRONMENT="%environmentExisting%"^
    -it "%environmentExisting%"^
    /bin/start.sh
  EXIT
)

@REM Otherwise, go through the new container creation prompts.
ECHO No container found with number %environmentNumber%
GOTO environmentPrompt

@REM =====================================================
@REM New Container Logic
@REM =====================================================
:newContainerStart
:domainPrompt
ECHO What is the custom domain for this project?
SET /p domain=""

IF "%domain%" == "" (
  ECHO %ESC%[31mPlease enter a domain.%ESC%[0m
  GOTO domainPrompt
)
SET domain = %domain: =%

:sandboxPrompt
ECHO What is the sandbox name (leave it blank for production)?
SET /p sandbox=""

IF "%sandbox%" == "" (
  SET environmentNew=%domain: =%
)
IF "%sandbox%" NEQ "" (
  SET environmentNew=%domain: =%--%sandbox: =%
)

@REM Remove spaces and replace nothing.
ECHO Pulling the latest image...
docker pull %dockerImage% > nul

ECHO Creating the container...
docker run^
  -v %cd%:/project^
  -e ENVIRONMENT="%environmentNew%"^
  --name "%environmentNew%"^
  -it "%dockerImage%"^
  /bin/start.sh
EXIT


@REM =====================================================
@REM Functions for colorization
@REM =====================================================
:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)
exit /B 0