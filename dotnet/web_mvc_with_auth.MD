Get a basic MVC application with 

### Objective(s)
- Postgres for backend
- Identity basic setup


### Pre-reqs
- Dotnet installed.
- "dotnet" command accessible from CLI.

### Tested On
- WSL 2

### Steps
- Install Entity Framework

```
dotnet tool install --global dotnet-ef
```

- Create MVC App with Individual Authentication.

```
dotnet new mvc --auth Individual -uld -o <app-name>
cd <app-name>
```

- Review contents

- Add individual authentication to the 

```
dotnet new mvc --auth Individual -uld -o <app-name>
cd <app-name>
```

- Install Code Generator
```
dotnet tool install dotnet-aspnet-codegenerator
```

- Add packages for Postgres
```
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 6.0.1
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL.Design --version 2.0.0-preview1
```

- Add package for Code Generation
```
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design
```

- Restore packages
```
dotnet restore
```

- Add IAM features to the app.

```
dotnet aspnet-codegenerator identity -dc <app-name>.Data.ApplicationDbContext --files "Account.Register;Account.Login;Account.Logout;Account.RegisterConfirmation;Account.Manage.PersonalData" --force
```


### The complete set of steps.

```
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
