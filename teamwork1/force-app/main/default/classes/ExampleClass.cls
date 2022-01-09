//Child class
public class ExampleClass extends TestAbstractClass {

public ExampleClass(String a, String b, String c) {
   
//use abstract class constructor using super. 
super(a, b, c);
}

public override String myAbstractMethod() {
return 'Abstract method implemented in child class!';
}

public override String myVirtualMethod() {
return 'Virtual method overridden in child class!';
} 

public String invokeMethodFromAbstractClass() {
    
String methods = '';
String aaa  = x;
//methods += myPrivateMethod();//error, private method is not accessible in child class
methods += myProtectedMethod();
methods += myPublicMethod();

return methods; //protected method from abstract class public method from abstract class
}
}