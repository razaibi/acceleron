Get a basic MVC application with Authentication

### Objective(s)
- Identity basic setup


### Pre-reqs
- Dotnet installed.
- "dotnet" command accessible from CLI.

### Tested On
- WSL 2

### Steps
- Create MVC App with Individual Authentication.

```bash
dotnet new mvc --auth Individual -uld -o <app-name>
cd <app-name>
```

- Add manifest file:

```bash
dotnet new tool-manifest
```

- Install Entity Framework

```bash
dotnet tool install dotnet-ef
```

- Review contents

- Add individual authentication to the 

```bash
dotnet new mvc --auth Individual -uld -o <app-name>
cd <app-name>
```

- Install Code Generator
```bash
dotnet tool install dotnet-aspnet-codegenerator
```

- Add packages for Postgres
```bash
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 6.0.1
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL.Design --version 1.1.0
```

- Add package for Code Generation
```bash
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design
```

- Restore packages
```bash
dotnet restore
```

- Add IAM features to the app.

```bash
dotnet aspnet-codegenerator identity -dc <app-name>.Data.ApplicationDbContext --files "Account.Register;Account.Login;Account.Logout;Account.RegisterConfirmation;Account.Manage.PersonalData" --force
```

- Create Initial Migration

```bash
dotnet ef migrations add CreateInitialSchema
```

- Commit Migration(s)
```bash
dotnet ef database update
```


- Recap of all commands

```bash
dotnet new mvc --auth Individual -uld -o <app-name>
cd <app-name>
dotnet new tool-manifest
dotnet tool install dotnet-ef
dotnet tool install dotnet-aspnet-codegenerator
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 6.0.1
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL.Design --version 1.1.0
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design
dotnet restore
dotnet aspnet-codegenerator identity -dc <app-name>.Data.ApplicationDbContext --files "Account.Register;Account.Login;Account.Logout;Account.RegisterConfirmation;Account.Manage.PersonalData" --force
dotnet ef migrations add CreateIdentitySchema
dotnet ef database update
```


#### For Postgres database only.


- Create file **docker-compose.yml**.

```bash
version: "3.3"
services:
  db:
    build:
      context: ./Docker
      dockerfile: db.Dockerfile
    volumes:
      - ./var/pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"
```

- Create file **Docker/init.sql**

```bash
CREATE USER <app-username>;
CREATE DATABASE <db-name>;
GRANT ALL PRIVILEGES ON DATABASE <db-name> TO <app-username>;
```

- Create file **Docker/db.Dockerfile**

```bash
FROM postgres:11.5-alpine
COPY init.sql /docker-entrypoint-initdb.d/
```

- Compose and start services.

```bash
docker-compose -f docker-compose.yml up --no-start
docker-compose -f docker-compose.yml start
```

- Replace the below in Program.cs
```csharp
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString)
);
```
with

```csharp
builder.Services.AddDbContext<ApplicationDbContext>(options =>
options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));
```

- Append the below in Program.cs:
```csharp
builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
    .AddEntityFrameworkStores<ApplicationDbContext>();
```

to look like this:

```csharp
builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();
```

- Navigate to AppSettings.json and switch the connection string 

from this:
```json
  "ConnectionStrings": {
    "DefaultConnection": "Server=(<hostname>)\\<db-name>;Database=<app-name-db>;Trusted_Connection=True;MultipleActiveResultSets=true"
  }
```
to this:
```json
  "ConnectionStrings": {
    "DefaultConnection": "Server=<hostname>;Port=5432;Database=<db-name>;User Id=<db-username>;Password=<db-password>;"
  }

```
