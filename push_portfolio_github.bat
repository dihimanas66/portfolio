@echo off
setlocal enabledelayedexpansion
title Push Portfolio vers GitHub - dihimanas66

REM =========================================================
REM   Script d'import du dossier "portfolio" vers GitHub
REM   Compte GitHub : dihimanas66
REM   Repo cible    : https://github.com/dihimanas66/portfolio
REM =========================================================

REM --- Chemin du projet (modifie si besoin) ---
set "PROJECT_DIR=%USERPROFILE%\Desktop\portfolio"
set "REPO_URL=https://github.com/dihimanas66/portfolio.git"
set "BRANCH=main"

echo.
echo ============================================
echo   Dossier projet : %PROJECT_DIR%
echo   Repo GitHub    : %REPO_URL%
echo ============================================
echo.

REM --- Verifier que le dossier existe ---
if not exist "%PROJECT_DIR%" (
    echo [ERREUR] Le dossier "%PROJECT_DIR%" est introuvable.
    echo Modifie la variable PROJECT_DIR en haut du script si le chemin est different.
    pause
    exit /b 1
)

cd /d "%PROJECT_DIR%"

REM --- Verifier que Git est installe ---
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] Git n'est pas installe ou pas dans le PATH.
    pause
    exit /b 1
)

REM --- Initialiser le depot git si necessaire ---
if not exist ".git" (
    echo [INFO] Initialisation du depot Git...
    git init
    git branch -M %BRANCH%
) else (
    echo [INFO] Depot Git deja initialise.
)

REM --- Config remote ---
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo [INFO] Ajout du remote origin...
    git remote add origin %REPO_URL%
) else (
    echo [INFO] Remote origin deja configure.
    git remote set-url origin %REPO_URL%
)

REM --- Verifier l'identite Git (nom / email) ---
git config user.name >nul 2>&1
if errorlevel 1 (
    set "GIT_NAME="
    set /p GIT_NAME="Ton nom (pour Git, ex: Anas Dihim) : "
    git config --global user.name "!GIT_NAME!"
)

git config user.email >nul 2>&1
if errorlevel 1 (
    set "GIT_EMAIL="
    set /p GIT_EMAIL="Ton email GitHub (ex: dihim.a070@ucd.ac.ma) : "
    git config --global user.email "!GIT_EMAIL!"
)

REM --- Demander un message de commit ---
set "COMMIT_MSG="
set /p COMMIT_MSG="Message de commit (Entree = 'Update portfolio') : "
if "!COMMIT_MSG!"=="" set "COMMIT_MSG=Update portfolio"

REM --- Ajouter et committer les fichiers ---
echo.
echo [INFO] Ajout des fichiers...
git add -A

git diff --cached --quiet
if errorlevel 1 (
    git commit -m "!COMMIT_MSG!"
) else (
    echo [INFO] Rien a committer, tous les fichiers sont deja a jour.
)

REM --- Push vers GitHub ---
echo.
echo [INFO] Push vers GitHub (%BRANCH%)...
git push -u origin %BRANCH%

if errorlevel 1 (
    echo.
    echo [ATTENTION] Le push a echoue.
    echo Causes possibles :
    echo  - Authentification GitHub requise ^(utilise un Personal Access Token comme mot de passe^)
    echo  - Le repo distant contient des commits que tu n'as pas en local ^(essaie: git pull origin %BRANCH% --allow-unrelated-histories^)
) else (
    echo.
    echo [SUCCES] Le projet a ete pousse vers %REPO_URL%
)

echo.
pause
