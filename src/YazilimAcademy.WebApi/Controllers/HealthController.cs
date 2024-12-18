using Microsoft.AspNetCore.Mvc;

namespace YazilimAcademy.WebApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class HealthController : ControllerBase
{
    [HttpGet]
    public IActionResult Get()
    {
        return Ok(new 
        { 
            Status = "Healthy",
            Timestamp = DateTime.UtcNow,
            Message = "YazilimAcademy API is running!"
        });
    }
}
