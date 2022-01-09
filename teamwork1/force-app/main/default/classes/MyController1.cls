public class MyController1 {

    public Integer aaa {get;set;}

    public MyController1(){
        this.aaa = 2;
    }
    
    public PageReference calc() {
        this.aaa = aaa*aaa;
        return null;
    }

}