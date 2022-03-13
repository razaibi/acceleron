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

```
dotnet new mvc --auth Individual -uld -o <app-name>
cd <app-name>
```

- Add manifest file:

```
dotnet new tool-manifest
```

- Install Entity Framework

```
dotnet tool install dotnet-ef
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
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL.Design --version 1.1.0
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

- Create Initial Migration

```
dotnet ef migrations add CreateInitialSchema
```

- Commit Migration(s)
```
dotnet ef database update
```


- Recap of all commands

```
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


- Start Postgres with Docker

```bash
docker run -d \
    --name <container_name> \
    -p 5432:5432 \
    --network host \
    -e POSTGRES_DB=<db_name> \
    -e POSTGRES_USER=<db_username> \
    -e POSTGRES_PASSWORD=<db_password> \
    postgres
```


- Replace the below in Program.cs
```csharp
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString)
);
```
with
```
services.AddDbContext<ApplicationDbContext>(options =>
options.UseNpgsql(Configuration.GetConnectionString("DefaultConnection")));
```

- Append the below in Program.cs:
```
builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
    .AddEntityFrameworkStores<ApplicationDbContext>();
```
to look like this:
```
builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();
```

- Navigate to AppSettings.json and switch the connection string 

from this:
```
  "ConnectionStrings": {
    "DefaultConnection": "Server=(<hostname>)\\<db-name>;Database=<app-name-db>;Trusted_Connection=True;MultipleActiveResultSets=true"
  }
```
to this:
```
  "ConnectionStrings": {
    "DefaultConnection": "Server=<hostname>;Port=5432;Database=<db-name>;User Id=<db-username>;Password=<db-password>;"
  }

```








