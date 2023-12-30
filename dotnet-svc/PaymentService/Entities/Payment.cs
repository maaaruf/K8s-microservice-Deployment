namespace PaymentService.Entities;

public class Payment
{
    public Guid Id { get; set; }
    public double Amount { get; set; }
    
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}