using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PaymentService.Data;
using PaymentService.Entities;
using PaymentService.Models;

namespace PaymentService.Controllers;

[ApiController]
[Route("/api/[action]")]
public class PaymentController : ControllerBase
{
    private readonly ILogger<PaymentController> _logger;
    private readonly ApplicationDbContext _dbContext;
    
    public PaymentController(
        ILogger<PaymentController> logger,
        ApplicationDbContext dbContext)
    {
        _logger = logger;
        _dbContext = dbContext;
    }
    
    // init method to initialize the database
    [HttpGet(Name = "Init")]
    public async Task<IActionResult> Init()
    {
        try
        {
            await _dbContext.Database.EnsureCreatedAsync();
            await _dbContext.Database.MigrateAsync();
            return Ok();
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error while initializing the database");
            return BadRequest(e);
        }
    }
    
    [HttpGet(Name = "GetPayments")]
    public async Task<IActionResult> LoadPayments()
    {
        try
        {
            var payments = _dbContext.Payments.ToList();
            return Ok(payments);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error while paying");
            return BadRequest(e);
        }
    }
    
    [HttpPost(Name = "pay")]
    public async Task<IActionResult> Pay([FromBody] PaymentCreateModel model)
    {
        try
        {
            var payment = new Payment
            {
                CreatedAt = DateTime.Now,
                Amount = model.Amount
            };
        
            await _dbContext.Payments.AddAsync(payment);
            await _dbContext.SaveChangesAsync();

            return Ok(payment);
        }
        catch (Exception e)
        {
            _logger.LogError(e, "Error while paying");
            return BadRequest(e);
        }
    }
    
    
}