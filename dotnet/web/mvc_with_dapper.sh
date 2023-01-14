# sudo rm -r SampleApp
# dotnet new mvc -o SampleApp -au Individual --framework=net7.0
# cd SampleApp
# dotnet new gitignore
# git init
# git add .
# git commit -m "Initialized project."

echo 'Adding packages...'
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design --version 7.0.1
dotnet tool install --global dotnet-aspnet-codegenerator --version 7.0.1
dotnet add package Microsoft.EntityFrameworkCore.Design --version 7.0.1
dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore --version 7.0.1
dotnet add package Microsoft.AspNetCore.Identity.UI --version 7.0.1
dotnet add package Microsoft.EntityFrameworkCore.Sqlite --version 7.0.1
dotnet add package Microsoft.EntityFrameworkCore.Tools --version 7.0.1
dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 7.0.1
dotnet add package Microsoft.Data.SqlClient --version 5.0.1
dotnet add package Dapper --version 2.0.123
echo 'Completed adding packages.'

echo '{
  "ConnectionStrings": {
    "IdentityDbConnection": "DataSource=app.db;Cache=Shared",
    "AppDbConnection": "Server=localhost;Database=SampleDb;User Id=sa;Password=iftahsesame123;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}' > ./appsettings.json

echo '{
  "ConnectionStrings": {
    "IdentityDbConnection": "DataSource=app.db;Cache=Shared",
    "AppDbConnection": "Server=localhost;Database=SampleDb;User Id=sa;Password=iftahsesame123;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
' > ./appsettings.Development.json

echo 'Adding GeneralDbContext and Model files...'

echo 'using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SampleApp.Models;

public class Blog
{
    [Key]
    public int BlogId { get; set; }
    [Display(Name = "Name")]
    [StringLength(100, MinimumLength = 3)]
    [Required]
    public string Name { get; set; } = "";
    public List<BlogPost> BlogPosts { get; set; } = new List<BlogPost>();
}
' > ./Models/Blog.cs

echo 'using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SampleApp.Models;

public class BlogPost
{
    [Key]
    public int Id { get; set; }
    public string Title { get; set; } = "";
    public string Content { get; set; } = "";

    public int BlogId { get; set; }
    public Blog Blog { get; set; }
}' > ./Models/BlogPost.cs

echo 'using Microsoft.EntityFrameworkCore;
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
}' > ./Data/GeneralDbContext.cs

echo 'using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using SampleApp.Data;
using SampleApp.Repositories;
using SampleApp.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
var identityDbConnectionString = builder.Configuration.GetConnectionString("IdentityDbConnection") ?? throw new InvalidOperationException("Connection string IdentityDbConnection not found.");
var appDbConnectionString = builder.Configuration.GetConnectionString("AppDbConnection") ?? throw new InvalidOperationException("Connection string AppDbConnection not found.");

builder.Services.AddDbContext<ApplicationDbContext>(options=>
    options.UseSqlite(identityDbConnectionString)
);

builder.Services.AddDbContext<GeneralDbContext>(options=>
    options.UseSqlServer(appDbConnectionString)
);

builder.Services.AddDatabaseDeveloperPageExceptionFilter();

builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
    .AddEntityFrameworkStores<ApplicationDbContext>();

builder.Services.AddControllersWithViews();

builder.Services.AddScoped<IProductRepository, ProductRepository>();
builder.Services.AddScoped<IProductService, ProductService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseMigrationsEndPoint();
}
else
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

// app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
app.MapRazorPages();

app.Run();' > ./Program.cs

echo 'Completed adding general db context.'

git add .
git commit -m "Updated project files."


# Working
# echo 'Adding identity files...'
# dotnet aspnet-codegenerator identity --dbContext=ApplicationDbContext --files "Account.Register;Account.Login;Account.Logout;Account.RegisterConfirmation;Account.Manage.Index;Account.ForgotPassword;Account.ForgotPasswordConfirmation;Account.ResetPassword;Account.ResetPasswordConfirmation;Account.Manage.TwoFactorAuthentication;" -sqlite

# dotnet ef migrations add IdentityCreate --context=ApplicationDbContext
# dotnet ef database update --context=ApplicationDbContext

# git add .
# git commit -m "Added identity files."

# echo 'Completed adding identity files.'


# echo 'Adding GeneralDBContext migrations...'
# dotnet ef migrations add AddedNewModels --context=GeneralDbContext
# dotnet ef database update --context=GeneralDbContext
# echo 'Completed adding GeneralDBContext'

# #-sqlite
# echo 'Generating controllers...'
# dotnet aspnet-codegenerator controller -name BlogController -m Blog -dc SampleApp.Data.GeneralDbContext --relativeFolderPath Controllers --useDefaultLayout --referenceScriptLibraries 
# dotnet aspnet-codegenerator controller -name BlogPostController -m BlogPost -dc SampleApp.Data.GeneralDbContext --relativeFolderPath Controllers --useDefaultLayout --referenceScriptLibraries 
#Working End

echo 'Completed generating controllers.'

# Additional
touch ./Models/BaseEntity.cs
echo 'namespace SampleApp.Models;

public abstract class BaseEntity
{
 
}' > ./Models/BaseEntity.cs

echo 'namespace SampleApp.Models;

public class Product : BaseEntity
{
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal? Price { get; set; }
    public int? Quantity { get; set; }
}' > ./Models/Product.cs

mkdir Repositories
touch ./Repositories/IRepository.cs
echo 'using SampleApp.Models;

namespace SampleApp.Repositories;

public interface IRepository<T> where T : BaseEntity
{
    Task<List<T>> GetAllAsync();
    Task<T> GetByIdAsync(int id);
    Task<int> CreateAsync(T entity);
    Task<int> UpdateAsync(T entity);
    Task<int> DeleteAsync(T entity);
}' > ./Repositories/IRepository.cs


touch ./Repositories/BaseRepository.cs
echo 'using Dapper;
using System.Data;
using Microsoft.Data.SqlClient;

namespace SampleApp.Repositories;

public abstract class BaseRepository
{
    private readonly IConfiguration _configuration;
 
    protected BaseRepository(IConfiguration configuration)
    {
        _configuration = configuration;
    }
 
    protected IDbConnection CreateConnection()
    {
        return new SqlConnection(_configuration.GetConnectionString("AppDbConnection"));
    } 
}' > ./Repositories/BaseRepository.cs

echo 'using SampleApp.Models;

namespace SampleApp.Repositories;

public interface IProductRepository : IRepository<Product>
{
}' > ./Repositories/IProductRepository.cs

echo 'using Dapper;
using System.Data;
using SampleApp.Models;

namespace SampleApp.Repositories;

public class ProductRepository : BaseRepository, IProductRepository
{
        public ProductRepository(IConfiguration configuration)
            : base(configuration)
        { }
 
        public async Task<List<Product>> GetAllAsync()
        {
            try
            {
                var query = "SELECT * FROM Products";
                using (var connection = CreateConnection())
                {
                    return (await connection.QueryAsync<Product>(query)).ToList();
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }
 
        public async Task<Product> GetByIdAsync(int id)
        {
            try
            {
                var query = "SELECT * FROM Products WHERE Id = @Id";
        
                var parameters = new DynamicParameters();
                parameters.Add("Id", id, DbType.Int32);
        
                using (var connection = CreateConnection())
                {
                    return (await connection.QueryFirstOrDefaultAsync<Product>(query, parameters));
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }
 
        public async Task<int> CreateAsync(Product entity)
        {
            try
            {
                var query = "INSERT INTO Products (Name, Price, Quantity) VALUES (@Name, @Price, @Quantity)";
        
                var parameters = new DynamicParameters();
                parameters.Add("Name", entity.Name, DbType.String);
                parameters.Add("Price", entity.Price, DbType.Decimal);
                parameters.Add("Quantity", entity.Quantity, DbType.Int32);
        
                using (var connection = CreateConnection())
                {
                    return (await connection.ExecuteAsync(query, parameters));
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }
 
        public async Task<int> UpdateAsync(Product entity)
        {
            try
            {
                var query = "UPDATE Products SET Name = @Name, Price = @Price, Quantity = @Quantity WHERE Id = @Id";
        
                var parameters = new DynamicParameters();
                parameters.Add("Name", entity.Name, DbType.String);
                parameters.Add("Price", entity.Price, DbType.Decimal);
                parameters.Add("Quantity", entity.Quantity, DbType.Int32);
                parameters.Add("Id", entity.Id, DbType.Int32);
        
                using (var connection = CreateConnection())
                {
                    return (await connection.ExecuteAsync(query, parameters));
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }
 
        public async Task<int> DeleteAsync(Product entity)
        {
            try
            {
                var query = "DELETE FROM Products WHERE Id = @Id";
        
                var parameters = new DynamicParameters();
                parameters.Add("Id", entity.Id, DbType.Int32);
        
                using (var connection = CreateConnection())
                {
                    return (await connection.ExecuteAsync(query, parameters));
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message, ex);
            }
        }
}' > ./Repositories/ProductRepository.cs

mkdir Services

echo 'using SampleApp.Models;

namespace SampleApp.Services;

public interface IProductService
{
    public Task<List<Product>> GetAllProducts();
    public Task<Product> GetProductById(int id);
    public Task<int> CreateProductAsync(Product product);
    public Task<int> UpdateProductAsync(Product product);
    public Task<int> DeleteProductAsync(Product product);
}' > ./Services/IProductService.cs

echo 'using SampleApp.Models;
using SampleApp.Repositories;

namespace SampleApp.Services;

public class ProductService : IProductService
{
    private readonly IProductRepository _productRepository;
 
    public ProductService(IProductRepository productRepository)
    {
        _productRepository = productRepository;
    }
 
    public async Task<List<Product>> GetAllProducts()
    {
        return await _productRepository.GetAllAsync();
    }
 
    public async Task<Product> GetProductById(int id)
    {
        return await _productRepository.GetByIdAsync(id);
    }
 
    public async Task<int> CreateProductAsync(Product product)
    {
        return await _productRepository.CreateAsync(product);
    }
 
    public async Task<int> UpdateProductAsync(Product product)
    {
        return await _productRepository.UpdateAsync(product);
    }
 
    public async Task<int> DeleteProductAsync(Product product)
    {
        return await _productRepository.DeleteAsync(product);
    }
}' > ./Services/ProductService.cs

echo 'using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using SampleApp.Services;

public class ProductsController : Controller
{
    private readonly IProductService _productService;
 
    public ProductsController(IProductService productService)
    {
        _productService = productService;
    }

    public async Task<IActionResult> Index()
    {
        return View(await _productService.GetAllProducts());
    }

    public async Task<IActionResult> Details(int id)
    {
        return View(await _productService.GetProductById(id));
    }
}
' > ./Controllers/ProductsController.cs

mkdir ./Views/Products
echo '@model IEnumerable<SampleApp.Models.Product>
 
@{
    ViewData["Title"] = "Index";
    Layout = "~/Views/Shared/_Layout.cshtml";
}
 
<div class="row">
    <div class="col">
        <h1>Products</h1>
    </div>
    <div class="col text-right">
        <a asp-action="Create" class="btn btn-success">Create New</a>
    </div>
</div>
 
<br/>
<table class="table">
    <thead>
        <tr>
            <th>
                @Html.DisplayNameFor(model => model.Id)
            </th>
            <th>
                @Html.DisplayNameFor(model => model.Name)
            </th>
            <th>
                @Html.DisplayNameFor(model => model.Price)
            </th>
            <th>
                @Html.DisplayNameFor(model => model.Quantity)
            </th> 
            <th></th>
        </tr>
    </thead>
    <tbody>
        @foreach (var item in Model) {
            <tr>
                <td>
                    @Html.DisplayFor(modelItem => item.Id)
                </td>
                <td>
                    @Html.DisplayFor(modelItem => item.Name)
                </td>
                <td>
                    @Html.DisplayFor(modelItem => item.Price)
                </td>
                <td>
                    @Html.DisplayFor(modelItem => item.Quantity)
                </td>
                <td>
                    @Html.ActionLink("Edit", "Edit", new { id = item.Id }, new { @class = "btn btn-primary" })  
                    @Html.ActionLink("Details", "Details", new { id=item.Id }, new { @class = "btn btn-secondary" })  
                    @Html.ActionLink("Delete", "Delete", new { id=item.Id }, new { @class = "btn btn-danger" })
                </td>
            </tr>
        }
    </tbody>
</table>' > ./Views/Products/Index.cshtml




dotnet build
