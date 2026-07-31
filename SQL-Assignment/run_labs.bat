@echo off
REM ============================================================
REM Runs run_all.sql through SQL*Plus and saves all output to
REM C:\Users\Nehal Sahu\Desktop\labs\all_output.txt
REM ============================================================

set LABDIR=C:\Users\Nehal Sahu\Desktop\labs

REM Make sure the labs folder exists
if not exist "%LABDIR%" mkdir "%LABDIR%"

REM Copy run_all.sql there if it isn't already
copy /Y "%~dp0run_all.sql" "%LABDIR%\run_all.sql"

REM Connect and run (edit username/password/host/port/SID if different)
sqlplus ora1/ora1@localhost:1521/orcl @"%LABDIR%\run_all.sql"

echo.
echo Done. Open "%LABDIR%\all_output.txt" to see everything.
pause
