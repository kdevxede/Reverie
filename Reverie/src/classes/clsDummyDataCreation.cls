@isTest
public class clsDummyDataCreation
{
    public static Account CreateAccount(String strName,String strPhone)
    {
        Account oAccount = new Account();
        oAccount.Name = strName;
        oAccount.Phone = strPhone;
        oAccount.BillingCity = 'Fremont';
        oAccount.BillingCountry = 'United States';
        oAccount.BillingState = 'California';
        oAccount.BillingStreet ='311, Parkvillage';
        oAccount.BillingPostalCode = '92604';
        oAccount.ShippingCity = 'Fremont';
        oAccount.ShippingCountry = 'United States';
        oAccount.ShippingState = 'California';
        oAccount.ShippingStreet ='311, Parkvillage';
        oAccount.ShippingPostalCode = '92604';
        insert oAccount;
        return oAccount;
    }
    public static Contact CreateContact(String strFirstName,String strLastName,Id AccountId,String strEmail)
    {
        Contact oContact = new Contact();
        oContact.FirstName = strFirstName;
        oContact.LastName = strLastName;
        oContact.AccountId = AccountId;
        oContact.Email = strEmail;
        insert oContact;
        return oContact;
    }
    
    public static Product_Code__c CreateProduct_Code()
    {
        Product_Code__c oProduct_Code = new Product_Code__c();
        oProduct_Code.Name = 'Full Motion Base: Twin XL';
        oProduct_Code.Control_System__c = 'Java';
        oProduct_Code.Product_Description__c = 'This is for testing';
        insert oProduct_Code;
        return oProduct_Code;
    }
    public static Component__c createComponent(String strName)
    {
        Component__c oComponent = new Component__c();
        oComponent.Name = strName;
        oComponent.Part_Description__c = 'J-Box  Custom Memory (N3) Tempurpedic PLC';
        insert oComponent;
        return oComponent;
    }
    public static Product_Code_Component__c CreateProduct_Code_Component(Id ComponentId,Id Product_CodeId)
    {
        Product_Code_Component__c oProduct_Code_Component = new Product_Code_Component__c();
        oProduct_Code_Component.Product_Code__c = Product_CodeId;
        oProduct_Code_Component.Component__c = ComponentId;
        insert oProduct_Code_Component;
        return oProduct_Code_Component;
    }
    public static Serial_Number__c CreateSerial_Number(String strName,Id ProductCodeId)
    {
        Serial_Number__c oSerial_Number = new Serial_Number__c();
        oSerial_Number.Name = strName;
        oSerial_Number.Product_Code__c =ProductCodeId;
        oSerial_Number.Manufacture_Date__c = System.today();
        insert oSerial_Number;
        return oSerial_Number;
    }
    public static Asset CreateAsset(String strName,String AccountId,String Serial_NumberId)
    {
        Asset oAsset = new Asset();
        oAsset.Name = strName;
        oAsset.AccountId = AccountId;
        oAsset.Serial_Number__c = Serial_NumberId;
        oAsset.Purchased_From__c = '2';
        insert oAsset;
        return oAsset;
    }
    public static Case CreateCase(Id ContactId,Id AccountId,Id AssetId,Id Serial_NumberId)
    {
        Case oCase = new Case();
        oCase.ContactId = ContactId;
        oCase.AccountId = AccountId;
        oCase.Asset__c = AssetId;
        oCase.Serial_Number__c = Serial_NumberId;
        insert oCase;
        return oCase;
    }
    public static Technician__c CreateTechnician(String strTech_Company_Name)
    {
        Technician__c oTechnician = new Technician__c();
        oTechnician.Tech_Company_Name__c = strTech_Company_Name;
        oTechnician.Tech_Phone__c = '9891798737';
        oTechnician.Tech_First_Name__c ='Test';
        oTechnician.Tech_Last_Name__c = 'Test';
        oTechnician.Tech_City__c = 'Phoenix';
        insert oTechnician;
        return oTechnician;
    }
    public static Technician_Assignment__c CreateTechnician_Assignment(Id CaseId,Id TechnicianId)
    {
        Technician_Assignment__c oTechnician_Assignment = new Technician_Assignment__c();
        oTechnician_Assignment.Case__c = CaseId;
        oTechnician_Assignment.Technician__c = TechnicianId;
        insert oTechnician_Assignment;
        return oTechnician_Assignment;
    }
    public static Shipment_Info__c CreateShipment_Info(Id Technician_AssignmentId)
    {
        Shipment_Info__c oShipment_Info = new Shipment_Info__c();
        oShipment_Info.Customer_City__c = 'Fremont';
        oShipment_Info.Customer_Name__c =  'Test';
        oShipment_Info.Customer_Phone__c = '9891798737';
        oShipment_Info.Customer_State__c = 'Califronia';
        oShipment_Info.Customer_Zip_Code__c = '201301';
        oShipment_Info.Purchased_From__c = '2';
        oShipment_Info.Shipping_City__c = 'Fremont';
        oShipment_Info.Shipping_Phone__c = '9891798737';
        oShipment_Info.Shipping_State__c = 'Califronia';
        oShipment_Info.Technician_Assignment__c = Technician_AssignmentId;
        insert oShipment_Info;
        return oShipment_Info;
    }
    
    public static Shipment_Info_Component__c CreateShipment_Info_Component(Id ComponentId,Id ShipmentInfoId,boolean isClosed,integer intQuantity,integer intQuantity_Received)
    {
        Shipment_Info_Component__c oShipment_Info_Component = new Shipment_Info_Component__c();
        oShipment_Info_Component.Component__c = ComponentId;
        oShipment_Info_Component.Shipment_Info__c = ShipmentInfoId;
        oShipment_Info_Component.Closed__c = isClosed;
        oShipment_Info_Component.Quantity__c = intQuantity;
        oShipment_Info_Component.Quantity_Received__c = intQuantity_Received;
        insert oShipment_Info_Component;
        return oShipment_Info_Component;
    }
    
}