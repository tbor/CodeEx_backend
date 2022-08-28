using DbUp;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Authorization;
using CodeEx_DSE.Authorization;
using CodeEx_DSE.Data;
using Microsoft.Extensions.Options;
using System.Diagnostics;

var builder = WebApplication.CreateBuilder(args);

//---------------------------------
// DbUp
//---------------------------------
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
EnsureDatabase.For.SqlDatabase(connectionString);
var upgrader = DeployChanges.To.SqlDatabase(connectionString, null).WithScriptsEmbeddedInAssembly(System.Reflection.Assembly.GetExecutingAssembly()).WithTransaction().Build();
if (upgrader.IsUpgradeRequired()) { upgrader.PerformUpgrade(); }


//---------------------------------
// Add services to the container.
//---------------------------------
//builder.Services.AddRazorPages();
builder.Services.AddControllers();

//-------------------------------------------------------------------------------------------------------------------------------

builder.Services.AddScoped<IDataRepository, DataRepository>();

var frontend = builder.Configuration["Frontend"];

builder.Services.AddCors(options => options.AddPolicy("CorsPolicy", builder => 
builder
.AllowAnyMethod()
.AllowAnyHeader()
.WithOrigins(frontend)));

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.Authority = builder.Configuration["Auth0:Authority"];
    options.Audience = builder.Configuration["Auth0:Audience"];
});

builder.Services.AddHttpClient();

builder.Services.AddAuthorization(options => options.AddPolicy("MustBeEventCoordinator", policy => policy.Requirements.Add(new MustBeEventCoordinatorRequirement())));
builder.Services.AddScoped<IAuthorizationHandler, MustBeEventCoordinatorHandler>();
builder.Services.AddHttpContextAccessor();

//-------------------------------------------------------------------------------------------------------------------------------

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. May want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();

    app.UseHttpsRedirection();
}

//app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();
app.UseAuthentication();
app.UseCors("CorsPolicy");
app.UseAuthorization();

//app.MapRazorPages();
app.MapControllers();

app.Run();


