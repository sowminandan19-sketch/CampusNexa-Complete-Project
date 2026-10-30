@echo off
title CampusNexa Host Server
cd /d "%~dp0"

echo ================================================================
echo  🏢 CampusNexa - Enterprise Maintenance Management System
echo ================================================================
echo  Starting Jetty host server on http://localhost:8080 ...
echo  Press Ctrl+C to stop the server at any time.
echo ================================================================

start "" "http://localhost:8080/login.html"
mvn jetty:run

