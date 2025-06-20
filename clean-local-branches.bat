@echo off
setlocal enabledelayedexpansion

echo.
echo ====================================================
echo   Git Local Branch Cleanup Utility
echo ====================================================
echo.
echo This will delete local Git branches that:
echo - No longer exist on the remote (GitHub)
echo - AND have already been merged into your current branch
echo.
echo Fetching and pruning remote branches...
git fetch --prune >nul

REM Prepare temp files
set "toDelete=%TEMP%\branches_to_delete.txt"
set "toKeep=%TEMP%\branches_to_keep.txt"
del "%toDelete%" >nul 2>&1
del "%toKeep%" >nul 2>&1

REM Get merged branches list into memory
for /f "delims=" %%m in ('git branch --merged') do (
    set "mergedBranches=!mergedBranches!%%m;"
)

REM Detect branches that are gone from remote
for /f "tokens=1,* delims= " %%a in ('git branch -vv') do (
    set "branch=%%a"
    echo %%b | findstr /c:": gone]" >nul
    if !errorlevel! == 0 (
        echo !mergedBranches! | findstr /c:" !branch!;" >nul
        if !errorlevel! == 0 (
            echo !branch!>>"%toDelete%"
        ) else (
            echo !branch!>>"%toKeep%"
        )
    ) else (
        echo !branch!>>"%toKeep%"
    )
)

echo.
if exist "%toDelete%" (
    echo Branches that will be DELETED:
    type "%toDelete%"
) else (
    echo No local branches are safe to delete.
)

echo.
if exist "%toKeep%" (
    echo Branches that will be KEPT:
    type "%toKeep%"
)

echo.

set /p userconfirm=Proceed to delete the above branches? (y/N): 
if /i not "%userconfirm%"=="y" (
    echo Aborted. No branches were deleted.
    del "%toDelete%" >nul
    del "%toKeep%" >nul
    goto :end
)

REM Delete merged & gone branches
if exist "%toDelete%" (
    for /f %%i in (%toDelete%) do (
        echo Deleting branch: %%i
        git branch -d %%i
    )
)

REM Cleanup
del "%toDelete%" >nul
del "%toKeep%" >nul

echo.
echo Cleanup complete.

:end
pause