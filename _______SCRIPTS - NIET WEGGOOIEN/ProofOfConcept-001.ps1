@echo off
cd "C:\Users\ericg\source\repos\dev\ProofOfConcept-001"
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "\ProofOfConcept-001.ps1"

# Stel de variabelen in
$root = "C:\Users\ericg\source\repos\dev\ProofOfConcept-001"
$projectName = "ProofOfConcept-001"

# Ga naar de root (zorg dat deze map bestaat)
if (!(Test-Path $root)) { New-Item -ItemType Directory -Path $root }
cd $root

# 1. Maak de Solution aan
dotnet new sln -n $projectName

# 2. Maak de Projecten aan
dotnet new webapi -n "$projectName.Api"
dotnet new classlib -n "$projectName.Services"
dotnet new classlib -n "$projectName.Data"
dotnet new classlib -n "$projectName.Models"
dotnet new classlib -n "$projectName.Development"
dotnet new classlib -n "$projectName.Common"

# 3. Mappenstructuur binnen Models (met dummy bestand voor zichtbaarheid)
$entitiesPath = "$root\$projectName.Models\Entities"
$dtosPath = "$root\$projectName.Models\DTOs"

New-Item -ItemType Directory -Path $entitiesPath -Force
New-Item -ItemType Directory -Path $dtosPath -Force

# Maak een leeg bestand aan zodat Visual Studio de mappen toont
New-Item -Path "$entitiesPath\.placeholder" -ItemType File -Force
New-Item -Path "$dtosPath\.placeholder" -ItemType File -Force

# 4. Voeg Projecten toe aan de Solution
dotnet sln add "$projectName.Api" "$projectName.Services" "$projectName.Data" "$projectName.Models" "$projectName.Development" "$projectName.Common"

# 5. Voeg Projectreferenties toe
dotnet add "$projectName.Api" reference "$projectName.Services" "$projectName.Models"
dotnet add "$projectName.Services" reference "$projectName.Data" "$projectName.Models"
dotnet add "$projectName.Data" reference "$projectName.Models"
dotnet add "$projectName.Common" reference "$projectName.Models"
dotnet add "$projectName.Development" reference "$projectName.Data"

# 6. Voeg NuGet Packages toe (zonder cd commando's om fouten te voorkomen)
# API
dotnet add "$projectName.Api" package AutoMapper

# Services (EF Core - versie 9.0.0 is de huidige stabiele voor .NET 9)
$efVersion = "9.0.0" 
dotnet add "$projectName.Services" package Microsoft.EntityFrameworkCore --version $efVersion
dotnet add "$projectName.Services" package Microsoft.EntityFrameworkCore.Abstractions --version $efVersion
dotnet add "$projectName.Services" package Microsoft.EntityFrameworkCore.Relational --version $efVersion
dotnet add "$projectName.Services" package Microsoft.EntityFrameworkCore.Design --version $efVersion
dotnet add "$projectName.Services" package Microsoft.EntityFrameworkCore.Tools --version $efVersion

# Data
dotnet add "$projectName.Data" package Microsoft.EntityFrameworkCore.SqlServer --version $efVersion

Write-Host "--- Solution Setup is voltooid, Eric! ---" -ForegroundColor Green
Write-Host "De mappen Entities en DTOs zijn nu zichtbaar in Visual Studio."