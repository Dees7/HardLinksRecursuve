@echo off
if [%1]==[] goto usage
set src=%~f1
set dst=%~f2

if "%dst:~-1%" neq "\" (
  set dst=%dst%\
)

setlocal EnableDelayedExpansion

for /r %src% %%i in (*.*) do (
    set pth=%%~fi
    set val=!pth:%src%\=!
    call :mkhlink "%dst%!val!" "!pth!"

)

goto :eof

:mkhlink
set dstdir="%~dp1"
set dst=%1
set src=%2
if NOT EXIST %dstdir% mkdir %dstdir%
if NOT EXIST %dst% mklink /h %dst% %src%
set dstdir=
set dst=
set src=
goto :eof

:usage
echo "Usage: %~n0 <sourse_dir> <destination_dir>"
echo "       sourse_dir - source directory to copy"
echo "       destination_dir - destination directory to copy. slash at the end needed c:\newplace\"


