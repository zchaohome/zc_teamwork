public abstract class TestAbstractClass {

protected String x;
public String y;
    public String z;

  public  TestAbstractClass() {}

public TestAbstractClass(String test1, String test2, String test3) {
x = test1;
y = test2;
z = test3;
}

abstract public String myAbstractMethod();

 virtual public String myVirtualMethod() {
return 'virtual method from abstract class';
}

private String myPrivateMethod() {
return 'private method from abstract class';
}

protected String myProtectedMethod() {
return 'protected method from abstract class';
}

public String myPublicMethod() {
return 'public method from abstract class';
}
}