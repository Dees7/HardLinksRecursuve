@echo off
if [%1]==[] goto usage
set src=%~f1
set dst=%~f2

rem добавляем слеш в конец если его нет
if "%dst:~-1%" neq "\" (
  set dst=%dst%\
)

if NOT EXIST %dst% mkdir %dst%

setlocal EnableDelayedExpansion 

rem перебираем файлы 
for /r %src% %%i in (*.*) do (
    set pth=%%~fi
    set val=!pth:%src%\=!
    call :mkhlink "%dst%!val!" "!pth!"

)
goto :eof


:mkhlink
set dstdir="%~dp1"
set srcdir="%~dp2"
set dst=%1
set src=%2
rem проверяем не линк ли папка от куда копируем
fsutil reparsepoint query "%srcdir:~1,-2%" > nul
if ERRORLEVEL 1 (
    rem если нет то создаем жескую ссылку
    if NOT EXIST %dstdir% mkdir %dstdir%
    if NOT EXIST %dst% mklink /h %dst% %src%
) else (
    rem если ссылка - ищем куда она указывает и создаем симлинк на папку
    if NOT EXIST %dstdir% ( 
        for /F "delims=? tokens=2,3" %%a in ('fsutil reparsepoint query "%srcdir:~1,-2%" ^| findstr ??') do set lnk=%%a
            set lnk=!lnk:~1!
            mklink /D %dstdir% "!lnk!" 
            
        )
)
set lnk=
set dstdir=
set srcdir=
set dst=
set src=
goto :eof

:usage
echo "Usage: %~n0 <sourse_dir> <destination_dir>"
echo "       sourse_dir - source directory to copy"
echo "       destination_dir - destination directory to copy"


