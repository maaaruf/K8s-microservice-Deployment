using Microsoft.AspNetCore.Mvc;
using PaymentService.Data;
using PaymentService.Entities;
using PaymentService.Models;

namespace PaymentService.Controllers;

[ApiController]
[Route("/api/[action]")]
public class HomeController : ControllerBase
{
    // public string Index()
    // {
    //     return "Hello from PaymentService";
    // }
}