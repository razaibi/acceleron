Get a basic MVC application with 

- Postgres for backend
- Identity basic setup

```
dotnet tool install --global dotnet-aspnet-codegenerator
dotnet tool install --global dotnet-ef
dotnet new mvc --auth Individual -uld -o <app-name>
cd <app-name>
dotnet new tool-manifest
dotnet tool install dotnet-aspnet-codegenerator
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 6.0.1
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL.Design --version 2.0.0-preview1
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design
dotnet restore
dotnet aspnet-codegenerator identity -dc <app-name>.Data.ApplicationDbContext --files "Account.Register;Account.Login;Account.Logout;Account.RegisterConfirmation;Account.Manage.PersonalData" --force
```
