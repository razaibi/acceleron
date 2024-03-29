Create App

```bash
dotnet new mvc -o SampleApp -au Individual --framework net6.0
cd SampleApp
```

Add packages

```bash
dotnet new tool-manifest
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design --version 6.0.0
dotnet tool install -g dotnet-aspnet-codegenerator --version 6.0.0
dotnet add package Microsoft.EntityFrameworkCore.Design --version 6.0.0
dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore --version 6.0.0
dotnet add package Microsoft.AspNetCore.Identity.UI --version 6.0.0
dotnet add package Microsoft.EntityFrameworkCore.Sqlite --version 6.0.0
dotnet add package Microsoft.EntityFrameworkCore.Tools --version 6.0.0
```

Add Identity Screens

```bash
dotnet aspnet-codegenerator identity -dc SampleApp.Data.ApplicationDbContext --files "Account.Register;Account.Login;Account.Logout;Account.RegisterConfirmation;Account.Manage.Index;Account.ForgotPassword;Account.ForgotPasswordConfirmation;Account.ResetPassword;Account.ResetPasswordConfirmation;Account.Manage.TwoFactorAuthentication;" -sqlite 
```

Create initial migration.

```bash
dotnet ef migrations add IdentityCreate
dotnet ef database update
```

Add the following classes (Blog, Post) to the Models folder.

```csharp
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SampleApp.Models;

public class Blog
{
    public int Id { get; set; }
    [Display(Name = "Blog Url")]
    [StringLength(100, MinimumLength = 3)]
    [Required]
    public string Name { get; set; } = "";

    public List<BlogPost> BlogPosts { get; set; }
}
```

```csharp
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SampleApp.Models;

public class BlogPost
{
    public int Id { get; set; }
    public string Title { get; set; }
    public string Content { get; set; }

    public int BlogId { get; set; }
    public Blog Blog { get; set; }
}
```

Ensure Program.cs has the following context added right after connection string declaration.

```csharp
builder.Services.AddDbContext<GeneralDbContext>(options=>
    options.UseSqlite(connectionString)
);

```

Ensure Data/ApplicationDbContext.cs looks like below.

```csharp
using Microsoft.EntityFrameworkCore;
using SampleApp.Models;

namespace SampleApp.Data;

public class GeneralDbContext : DbContext
{
    public DbSet<Blog> Blogs { get; set; }
    public DbSet<BlogPost> BlogPosts { get; set; }

    public GeneralDbContext(DbContextOptions<GeneralDbContext> options)
        : base(options)
    {
    }

    /*
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Blog>()
            .HasMany(b => b.BlogPosts)
            .WithOne();
    }
    */
}
```

```csharp
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SampleApp.Models;

public class Project
{
    public int Id { get; set; }
    [Display(Name = "Project Name")]
    [StringLength(100, MinimumLength = 3)]
    [Required]
    public string Name { get; set; } = "";
    [Display(Name = "Start Date")]
    [DataType(DataType.Date)]
    public DateTime? StartDate { get; set; }
    [Display(Name = "Projected End Date")]
    [DataType(DataType.Date)]
    public DateTime? ProjectedEndDate { get; set; }
    [Display(Name = "Actual End Date")]
    [DataType(DataType.Date)]
    public DateTime? ActualEndDate { get; set; }
    [Display(Name = "Description")]
    public string? Desc { get; set; }
}
```

Create a second migration.

```bash
dotnet ef migrations add AddedNewModels --context=GeneralDbContext
dotnet ef database update --context=GeneralDbContext
```

Generate CRUD Screens

```bash
dotnet aspnet-codegenerator controller -name ProjectController -m Project -dc SampleApp.Data.GeneralDbContext --relativeFolderPath Controllers --useDefaultLayout --referenceScriptLibraries -sqlite
```

Comment below in Progam.cs as shown.

```csharp
// app.UseHttpsRedirection();
```

Run Using

```bash
dotnet run
```

Ensure ConnectionStrings are setup as such in appsettings.json.

```json
  "ConnectionStrings": {
    "DefaultConnection": "DataSource=app.db;Cache=Shared",
    "DevAppDBContext" : "DataSource=app.db;Cache=Shared",
    "ProdAppDBContext" : ""
  },
```


To Secure Pages, navigate to controller, add package import and _Authorize_ tag.

```csharp
using Microsoft.AspNetCore.Authorization;
```

Example Authorize tag

```csharp
namespace SampleApp.Controllers;

[Authorize]
public class ProjectController : Controller
```