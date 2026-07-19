$ErrorActionPreference = "Stop"

function Write-Step($message) {
  Write-Host ""
  Write-Host "==> $message" -ForegroundColor Cyan
}

function Test-Command($name) {
  return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

function Invoke-Pnpm($Arguments) {
  if ($script:PnpmMode -eq "global") {
    & pnpm @Arguments
  } else {
    & npm exec --yes pnpm@11.7.0 -- @Arguments
  }

  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

function Find-MysqlCli {
  $candidates = @(
    "C:\xampp\mysql\bin\mysql.exe",
    "D:\xampp\mysql\bin\mysql.exe"
  )

  foreach ($candidate in $candidates) {
    if (Test-Path -LiteralPath $candidate) {
      return $candidate
    }
  }

  $command = Get-Command "mysql.exe" -ErrorAction SilentlyContinue
  if ($command) {
    return $command.Source
  }

  return $null
}

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $root

Write-Host "CRM Mini XAMPP Launcher" -ForegroundColor Green
Write-Host "Project: $root"

if (-not (Test-Command "node")) {
  Write-Host ""
  Write-Host "Node.js is not installed or is not available in PATH." -ForegroundColor Red
  Write-Host "Install Node.js LTS from https://nodejs.org, then run start-crm-mini.bat again."
  exit 1
}

$nodeVersion = node --version
Write-Host "Node.js: $nodeVersion"

if (Test-Command "pnpm") {
  $script:PnpmMode = "global"
  Write-Host "pnpm: $(pnpm --version)"
} else {
  if (-not (Test-Command "npm")) {
    Write-Host ""
    Write-Host "npm is not installed or is not available in PATH." -ForegroundColor Red
    Write-Host "Install Node.js LTS with npm enabled, then run this launcher again."
    exit 1
  }

  $script:PnpmMode = "npm-exec"
  Write-Step "Preparing pnpm without admin permission"
  Invoke-Pnpm @("--version")
}

$clientEnvPath = Join-Path $root "client\.env.local"
"VITE_API_URL=http://localhost:4000/api" | Set-Content -Path $clientEnvPath -Encoding UTF8
Write-Host "Frontend will use local API: http://localhost:4000/api"

$needsInstall = -not (Test-Path (Join-Path $root "node_modules"))

Write-Step "Preparing local configuration"
node scripts/prepare-demo.js

if ($needsInstall) {
  Write-Step "Installing dependencies"
  Invoke-Pnpm @("install")
} else {
  Write-Host "Dependencies already installed."
}

Write-Step "Checking XAMPP MySQL"
$mysqlReady = Test-NetConnection -ComputerName "127.0.0.1" -Port 3306 -InformationLevel Quiet
if (-not $mysqlReady) {
  Write-Host "MySQL is not running on port 3306." -ForegroundColor Red
  Write-Host "Open XAMPP Control Panel, start MySQL, then run this launcher again."
  exit 1
}

$mysqlCli = Find-MysqlCli
if (-not $mysqlCli) {
  Write-Host "mysql.exe was not found." -ForegroundColor Red
  Write-Host "Create database crm_mini_xampp in phpMyAdmin, then run this launcher again."
  exit 1
}

Write-Host "Creating database crm_mini_xampp if needed."
& $mysqlCli -u root -e "CREATE DATABASE IF NOT EXISTS crm_mini_xampp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
if ($LASTEXITCODE -ne 0) {
  Write-Host "Could not create database with mysql.exe." -ForegroundColor Red
  Write-Host "Create database crm_mini_xampp in phpMyAdmin, then run this launcher again."
  exit $LASTEXITCODE
}

Write-Step "Preparing MySQL tables and demo data"
Invoke-Pnpm @("run", "seed")

Write-Step "Starting CRM Mini"
Write-Host "The app will open at http://localhost:5173"
Write-Host "Keep this window open while using the app."
Start-Process "http://localhost:5173"

Invoke-Pnpm @("run", "dev")
