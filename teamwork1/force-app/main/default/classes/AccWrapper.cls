public class AccWrapper {
        @AuraEnabled
        public Account accRecord    { get; set; }
        //@AuraEnabled
        //public Boolean isSelected { get; set; }

        public AccWrapper(Account accRecord){
            //this.isSelected = false;
            this.accRecord = accRecord;
        }
    }