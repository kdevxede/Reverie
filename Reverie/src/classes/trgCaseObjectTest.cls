@isTest
private class  trgCaseObjectTest
{
    static testMethod void RunTestMethod1()
    {
        Account oAccount = clsDummyDataCreation.CreateAccount('Test','9891798773');
        Contact oContact = clsDummyDataCreation.CreateContact('Test','Test1',oAccount.Id,'test@gmail.com');
        Component__c oCompnent1 = clsDummyDataCreation.createComponent('X');
        Component__c oCompnent2 = clsDummyDataCreation.createComponent('Y');
        Component__c oCompnent3 = clsDummyDataCreation.createComponent('Z');
        Product_Code__c oProduct_Code = clsDummyDataCreation.CreateProduct_Code();
        Product_Code_Component__c oProduct_Code_Component1 = clsDummyDataCreation.CreateProduct_Code_Component(oCompnent1.Id,oProduct_Code.Id);
        Product_Code_Component__c oProduct_Code_Component2 = clsDummyDataCreation.CreateProduct_Code_Component(oCompnent2.Id,oProduct_Code.Id);
        Product_Code_Component__c oProduct_Code_Component3 = clsDummyDataCreation.CreateProduct_Code_Component(oCompnent3.Id,oProduct_Code.Id);
        Serial_Number__c oSerial_Number = clsDummyDataCreation.CreateSerial_Number('12345',oProduct_Code.Id);
        Asset oAsset =  clsDummyDataCreation.CreateAsset('Test',oAccount.Id,oSerial_Number.Id);
        Case oCase = clsDummyDataCreation.CreateCase(oContact.Id,oAccount.Id,oAsset.Id,null);
     }
      static testMethod void RunTestMethod2()
    {
        Account oAccount = clsDummyDataCreation.CreateAccount('Test','9891798773');
        Contact oContact = clsDummyDataCreation.CreateContact('Test','Test1',oAccount.Id,'test@gmail.com');
        Component__c oCompnent1 = clsDummyDataCreation.createComponent('X');
        Component__c oCompnent2 = clsDummyDataCreation.createComponent('Y');
        Component__c oCompnent3 = clsDummyDataCreation.createComponent('Z');
        Product_Code__c oProduct_Code = clsDummyDataCreation.CreateProduct_Code();
        Product_Code_Component__c oProduct_Code_Component1 = clsDummyDataCreation.CreateProduct_Code_Component(oCompnent1.Id,oProduct_Code.Id);
        Product_Code_Component__c oProduct_Code_Component2 = clsDummyDataCreation.CreateProduct_Code_Component(oCompnent2.Id,oProduct_Code.Id);
        Product_Code_Component__c oProduct_Code_Component3 = clsDummyDataCreation.CreateProduct_Code_Component(oCompnent3.Id,oProduct_Code.Id);
        Serial_Number__c oSerial_Number = clsDummyDataCreation.CreateSerial_Number('12345',oProduct_Code.Id);
        Asset oAsset =  clsDummyDataCreation.CreateAsset('Test',oAccount.Id,oSerial_Number.Id);
        Case oCase = clsDummyDataCreation.CreateCase(oContact.Id,oAccount.Id,null,null);
        oCase.Asset__c = oAsset.Id;
        update oCase;
     }
}