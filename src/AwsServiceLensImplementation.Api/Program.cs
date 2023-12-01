using Amazon;
using Amazon.XRay.Recorder.Core;
using Amazon.XRay.Recorder.Handlers.AwsSdk;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();

var app = builder.Build();

// Configure the HTTP request pipeline
AWSXRayRecorder.InitializeInstance(configuration: app.Configuration);
AWSSDKHandler.RegisterXRayForAllServices();
AWSXRayRecorder.RegisterLogger(LoggingOptions.Console);

app.UseHttpsRedirection();

app.UseExceptionHandler("/Error");
app.UseXRay("WeatherForecast");

app.UseAuthorization();

app.MapControllers();



app.Run();
