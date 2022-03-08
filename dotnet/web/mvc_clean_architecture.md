Create MVC app following clean architecture pattern.

### Objective(s)
- Setup MVC web app with clean architecture setup.


### Pre-reqs
- Dotnet installed.
- "dotnet" command accessible from CLI.

### Steps

- Create solution and base folders.

```bash
mkdir SampleSol
cd SampleSol
dotnet new sln --name SampleSol
mkdir src
mkdir tests
```

- Create **Domain, Application, Data, Inversion of Control** project.

```bash
cd src
dotnet new classlib --name SampleSol.Domain
dotnet new classlib --name SampleSol.Application
dotnet new classlib --name SampleSol.Infra.Data
dotnet new classlib --name SampleSol.Infra.IoC
dotnet new mvc --name SampleSol.WebUI
cd ..
```

- Create Test

```bash
cd tests
dotnet new xunit --name SampleSol.Domain.Tests
cd ..
```

- Add projects to solution.

```bash
dotnet sln add SampleSol.sln src/SampleSol.Domain/SampleSol.Domain.csproj
dotnet sln add SampleSol.sln src/SampleSol.Application/SampleSol.Application.csproj
dotnet sln add SampleSol.sln src/SampleSol.Infra.Data/SampleSol.Infra.Data.csproj
dotnet sln add SampleSol.sln src/SampleSol.Infra.IoC/SampleSol.Infra.IoC.csproj
dotnet sln add SampleSol.sln src/SampleSol.WebUI/SampleSol.WebUI.csproj
```


#Add references

```bash
cd src
dotnet add ../tests/SampleSol.Domain.Tests reference SampleSol.Domain/SampleSol.Domain.csproj
dotnet add SampleSol.Infra.Data reference SampleSol.Domain/SampleSol.Domain.csproj
dotnet add SampleSol.Infra.IoC reference SampleSol.Domain/SampleSol.Domain.csproj
dotnet add SampleSol.Infra.IoC reference SampleSol.Application/SampleSol.Application.csproj
dotnet add SampleSol.Infra.IoC reference SampleSol.Infra.Data/SampleSol.Infra.Data.csproj
dotnet add SampleSol.WebUI reference SampleSol.Infra.IoC/SampleSol.Infra.IoC.csproj
cd ..
```