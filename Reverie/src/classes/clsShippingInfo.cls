public class clsShippingInfo {

    public string CurrentPageId {get;set;}
    public Shipment_Info__c oShipmet_Info {get;set;}
    public Shipment_Info__c oShipment_Info{get;set;}
    public Technician_Assignment__c oTechnician_Assignment {get;set;}
    public List<ShipmentInfoComponent> ShipmentInfoComponents{get;set;}
    public boolean isPageEditable {get;set;}
    public boolean isShippingInfoExit {get;set;}
    public clsShippingInfo()
    {
        CurrentPageId = ApexPages.CurrentPage().getParameters().get('Id');
        isPageEditable = false;
        oShipment_Info = new Shipment_Info__c();
        ShipmentInfoComponents = new List<ShipmentInfoComponent>(); 
        if(CurrentPageId != null)
        {
            
            oTechnician_Assignment  = [Select Id,
                                              Case__c,
                                              Case__r.AccountId,
                                              Case__r.ContactId,
                                              Case__r.Contact.LastName,
                                              Case__r.Contact.FirstName,
                                              Case__r.Account.Name,
                                              Case__r.Asset__r.Purchased_From__c,
                                              Case__r.Account.BillingCity,
                                              Case__r.Account.BillingCountry,
                                              Case__r.Account.BillingPostalCode,
                                              Case__r.Account.BillingState,
                                              Case__r.Account.BillingStreet, 
                                              Case__r.Account.ShippingCity,
                                              Case__r.Account.ShippingCountry,
                                              Case__r.Account.ShippingPostalCode,
                                              Case__r.Account.Phone,
                                              Case__r.Account.ShippingState,
                                              Case__r.Account.ShippingStreet,
                                              Case__r.Asset.Purchased_From__c,
                                              Case__r.Serial_Number__r.Product_Code__c,
                                             (Select Id from Shipment_Info__r) 
                                      from Technician_Assignment__c Where ID =:CurrentPageId];
           
        }
        if(oTechnician_Assignment !=null && oTechnician_Assignment.Shipment_Info__r != null && oTechnician_Assignment.Shipment_Info__r.size()>0)
        {
            isShippingInfoExit = true;
        }
        ShipmentInfoComponents  = getShipmentInfoComponents();
    }
    public List<ShipmentInfoComponent> getShipmentInfoComponents()
    {
        
        ShipmentInfoComponents = new List<ShipmentInfoComponent>();
        if(oTechnician_Assignment !=null)
        {
        for(Product_Code_Component__c oPCC : [Select Id,
                                                     Name,
                                                     Component__c,
                                                     Obsolete__c,
                                                     Part_Description__c,
                                                     Product_Code__c,
                                                     Quantity__c,
                                                     Replacement_Part__c,
                                                     Weight__c 
                                              From Product_Code_Component__c Where Product_Code__c =: oTechnician_Assignment.Case__r.Serial_Number__r.Product_Code__c])
        {
            ShipmentInfoComponent oShipmentInfoComponent = new ShipmentInfoComponent(oPCC);
            //oShipmentInfoComponent.oComponent = objComponent;
            ShipmentInfoComponents.add(oShipmentInfoComponent);
        }
        }
        return  ShipmentInfoComponents;
    }
    public PageReference SaveComponent() {
        Shipment_Info__c oShipment_Info = new Shipment_Info__c();
        String strName = '';
        if(oTechnician_Assignment.Case__r.Contact.FirstName !=null && oTechnician_Assignment.Case__r.Contact.FirstName !='')
        strName += oTechnician_Assignment.Case__r.Contact.FirstName+ ' ';
        if(oTechnician_Assignment.Case__r.Contact.LastName !=null && oTechnician_Assignment.Case__r.Contact.LastName !='')
        strName += oTechnician_Assignment.Case__r.Contact.LastName;
        oShipment_Info.Customer_City__c = oTechnician_Assignment.Case__r.Account.BillingCity;
        oShipment_Info.Customer_Name__c = strName;
        oShipment_Info.Customer_State__c= oTechnician_Assignment.Case__r.Account.BillingState;
        oShipment_Info.Customer_Zip_Code__c= oTechnician_Assignment.Case__r.Account.BillingPostalCode;
        oShipment_Info.Customer_Address__c= oTechnician_Assignment.Case__r.Account.BillingStreet;
        oShipment_Info.Shipping_Address__c= oTechnician_Assignment.Case__r.Account.ShippingCity;
        oShipment_Info.Shipping_City__c= oTechnician_Assignment.Case__r.Account.ShippingCity;
        oShipment_Info.Shipping_State__c= oTechnician_Assignment.Case__r.Account.ShippingState;
        oShipment_Info.Shipping_Zip_Code__c= oTechnician_Assignment.Case__r.Account.ShippingPostalCode;
        oShipment_Info.Ship_To_Name__c = strName ;//oTechnician_Assignment.Case__r.Contact.FirstName +' ' +oTechnician_Assignment.Case__r.Contact.LastName;
        oShipment_Info.Shipping_Address__c = oTechnician_Assignment.Case__r.Account.ShippingStreet;
        oShipment_Info.Technician_Assignment__c= CurrentPageId;
        oShipment_Info.Shipping_Phone__c = oTechnician_Assignment.Case__r.Account.Phone;
        oShipment_Info.Customer_Phone__c = oTechnician_Assignment.Case__r.Account.Phone;
        oShipment_Info.Purchased_From__c = oTechnician_Assignment.Case__r.Asset__r.Purchased_From__c;
        insert oShipment_Info;
        List<Shipment_Info_Component__c> lstShipment_Info_Component = new List<Shipment_Info_Component__c>();
        system.debug('This is ShipmentInfoComponents :'+ShipmentInfoComponents);
        for(ShipmentInfoComponent oShipmentInfoComponent :ShipmentInfoComponents)
        {
            if(oShipmentInfoComponent.isChecked)
            {
                system.debug('oShipmentInfoComponent.oComponent :'+oShipmentInfoComponent.oComponent);
                system.debug('this is oShipmentInfoComponent.oShipment_Info_Component :'+oShipmentInfoComponent.oShipment_Info_Component);
                Shipment_Info_Component__c oSIC = new Shipment_Info_Component__c();
                oSIC.Name = oShipmentInfoComponent.oComponent.Name;
                oSIC.Component__c = oShipmentInfoComponent.oComponent.Component__c;
                oSIC.Quantity__c = oShipmentInfoComponent.oShipment_Info_Component.Quantity__c;
                oSIC.Status__c = oShipmentInfoComponent.oShipment_Info_Component.Status__c;
                oSIC.Closed__c = oShipmentInfoComponent.oShipment_Info_Component.Closed__c;
                oSIC.Quantity_Received__c = oShipmentInfoComponent.oShipment_Info_Component.Quantity_Received__c;
                oSIC.Shipment_Info__c =  oShipment_Info.Id;
                lstShipment_Info_Component.add(oSIC);
            }
        }
        insert lstShipment_Info_Component;
        isPageEditable = true;
        PageReference  oPage = new PageReference('/apex/vfShippingInfoDetail?Id='+oShipment_Info.Id);
        oPage.setRedirect(true);
        return oPage;
    }
    
   
    public PageReference EditShipTo() {
        isPageEditable = false;
        return null;
    }
    public PageReference CancelShipTo() {
        PageReference  oPage = new PageReference('/'+CurrentPageId);
        oPage.setRedirect(true);
        return oPage;
    }

    public class ShipmentInfoComponent
    {
        public Shipment_Info_Component__c oShipment_Info_Component {get;set;}
        public Product_Code_Component__c oComponent {get;set;}
        public boolean isChecked {get;set;}
        public ShipmentInfoComponent(Product_Code_Component__c  objCom)
        {
             oComponent =   objCom;
             isChecked  = false;
             oShipment_Info_Component = new Shipment_Info_Component__c();
        }
    }
}