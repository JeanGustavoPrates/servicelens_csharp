using Amazon.XRay.Recorder.Core;
using Microsoft.AspNetCore.Mvc;
using System.Net.Http;

namespace AwsServiceLensImplementation.Api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;
        private readonly HttpClient _httpClient;

        public WeatherForecastController(ILogger<WeatherForecastController> logger)
        {
            _logger = logger;
            _httpClient = new HttpClient();
        }

        [HttpGet]
        public async Task<IEnumerable<WeatherForecast>> Get()
        {
            AWSXRayRecorder.Instance.BeginSubsegment("GenerateWeatherForecast");
            try
            {
                AWSXRayRecorder.Instance.AddAnnotation("Method", "Get");
                var forecasts = await GenerateForecastsAsync();
                AWSXRayRecorder.Instance.EndSubsegment();
                return forecasts;
            }
            catch (Exception ex)
            {
                AWSXRayRecorder.Instance.AddException(ex);
                AWSXRayRecorder.Instance.EndSubsegment();
                throw;
            }
        }

        private async Task<IEnumerable<WeatherForecast>> GenerateForecastsAsync()
        {
            // Simulating an external call to a service like Google
            AWSXRayRecorder.Instance.BeginSubsegment("ExternalServiceCall");
            try
            {
                var response = await _httpClient.GetStringAsync("https://www.google.com");
                AWSXRayRecorder.Instance.AddAnnotation("ExternalServiceResponseLength", response.Length);
            }
            catch (Exception ex)
            {
                AWSXRayRecorder.Instance.AddException(ex);
                throw;
            }
            finally
            {
                AWSXRayRecorder.Instance.EndSubsegment();
            }

            return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            })
            .ToArray();
        }
    }
}

public class WeatherForecast
{
    public DateOnly Date { get; set; }
    public int TemperatureC { get; set; }
    public string Summary { get; set; }
}
