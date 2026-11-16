
using Xunit;

namespace SampleApi.Tests;

public class UnitTest1
{
    [Fact]
    public void TemperatureF_ConvertsCelsiusToFahrenheit()
    {
        // Arrange
        var forecast = new SampleApi.WeatherForecast
        {
            TemperatureC = 20
        };

        // Act
        int fahrenheit = forecast.TemperatureF;

        // Assert
        Assert.Equal(68, fahrenheit);
    }
}
