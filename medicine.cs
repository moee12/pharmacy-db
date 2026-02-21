public class Medicine
{
    public int MedicineID { get; set; }
    public string Name { get; set; }
    public string Form { get; set; }
    public string Strength { get; set; }
    public bool PrescriptionRequired { get; set; }
    public int StockAlertThreshold { get; set; }
}