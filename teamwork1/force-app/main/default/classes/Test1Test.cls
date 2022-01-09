@isTest
private class Test1Test {

    @isTest
    private static void testGetFormat(){
        Decimal st = 3.5;
        Test.startTest();
        Decimal result = Test1.getFormat(st);
        Test.stopTest();
        System.assertEquals(350, result);      
    }
}