public class CurrencyDecimal2 {
Public static String CurrencyResult;

Public static string Result(Decimal addDecimalPoint)
{
return addDecimalPoint(addDecimalPoint);
}



private static String addDecimalPoint(Decimal price)

{
CurrencyResult = String.valueOf(price.divide(1, 2));
Return CurrencyResult;
}
}