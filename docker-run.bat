@echo off
title CampusNexa Docker Launcher
cd /d "%~dp0"

echo ================================================================
echo  🐳 CampusNexa - Docker Deployment Launcher
echo ================================================================

:: Check if Docker CLI is in PATH
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker CLI not found in PATH!
    echo Please make sure Docker Desktop is installed.
    pause
    exit /b 1
)

:: Check if Docker daemon is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo [NOTICE] Docker engine is not running yet.
    echo Starting Docker Desktop...
    start "" "C:\Users\NANDA\AppData\Local\Programs\DockerDesktop\Docker Desktop.exe"
    echo Waiting for Docker engine to become ready...
    
    :wait_loop
    timeout /t 4 /nobreak >nul
    docker info >nul 2>&1
    if %errorlevel% neq 0 (
        echo Still waiting for Docker engine to initialize...
        goto wait_loop
    )
)

echo.
echo [OK] Docker engine is ready!
echo Building and launching CampusNexa containers (App + MySQL)...
echo.

docker compose up -d --build

echo.
echo ================================================================
echo  ✅ CampusNexa is deployed and running in Docker!
echo  👉 Web Application: http://localhost:8080/login.html
echo  👉 MySQL Database: localhost:3306 (maintenance_db)
echo.
echo  Commands:
echo   - View live logs:  docker compose logs -f
echo   - Stop containers: docker compose down
echo ================================================================
echo.
start "" "http://localhost:8080/login.html"
pause

