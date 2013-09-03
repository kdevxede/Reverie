public class clsEditShippingInfo{

    public clsEditShippingInfo(ApexPages.StandardController controller) {
        CurrentPageId = ApexPages.CurrentPage().getParameters().get('Id');
        isPageEditable = false;
        isComponentEditable = true;
        mComponentId_Shipment_Info_Component = new Map<Id,Shipment_Info_Component__c>();
        ShipmentInfoComponents = new List<ShipmentInfoComponent>(); 
        if(CurrentPageId != null)
        {
             oShipment_Info = [SELECT Case__c,
                                       Concern__c,
                                       Customer_Address__c,
                                       Customer_City__c,
                                       Shipping_Phone__c,
                                       Customer_Phone__c,
                                       Customer_Name__c,
                                       Customer_State__c,
                                       Customer_Zip_Code__c,
                                       Name,
                                       Product__c,
                                       Purchase_Date__c,
                                       Service_Technician__c,
                                       Shipping_Address__c,
                                       Shipping_City__c,
                                       Shipping_State__c,
                                       Shipping_Zip_Code__c,
                                       Ship_To_Name__c,
                                       Technician_Assignment__c,
                                       Technician_Assignment__r.Name,
                                       Technician_Assignment__r.Case__r.Asset__r.Purchased_From__c,
                                       Technician_Assignment__r.Case__r.Serial_Number__r.Product_Code__c,
                                       Manufacture_Date__c,
                                       (Select Id,Closed__c,Name,Component__c,Component__r.Name,Part_Description__c,Quantity__c,Quantity_Received__c,Shipment_Info__c,Status__c from Shipment_Info_Components__r) 
                                FROM Shipment_Info__c Where Id=: CurrentPageId limit 1];
            
        }
        for(Shipment_Info_Component__c objComponent : oShipment_Info.Shipment_Info_Components__r)
        {
            mComponentId_Shipment_Info_Component.put(objComponent.Component__c,objComponent);
        }
        
        ShipmentInfoComponents  = getShipmentInfoComponents();
    }


    public string CurrentPageId {get;set;}
    public Shipment_Info__c oShipment_Info {get;set;}
    public Technician_Assignment__c oTechnician_Assignment {get;set;}
    public List<ShipmentInfoComponent> ShipmentInfoComponents{get;set;}
    public boolean isPageEditable {get;set;}
    public boolean isShippingInfoExit {get;set;}
    public boolean isComponentEditable{get;set;}
    public Map<Id,Shipment_Info_Component__c> mComponentId_Shipment_Info_Component;
    
  
   
    public List<ShipmentInfoComponent> getShipmentInfoComponents()
    {
        
        ShipmentInfoComponents = new List<ShipmentInfoComponent>();
         System.debug('This is mComponentId_Shipment_Info_Component :'+mComponentId_Shipment_Info_Component);
        for(Product_Code_Component__c oPCC : [Select Id,
                                                     Name,
                                                     Component__c,
                                                     Obsolete__c,
                                                     Part_Description__c,
                                                     Product_Code__c,
                                                     Quantity__c,
                                                     Replacement_Part__c,
                                                     Weight__c 
                                              From Product_Code_Component__c Where Product_Code__c =: oShipment_Info.Technician_Assignment__r.Case__r.Serial_Number__r.Product_Code__c])
        {
            system.debug('This is oPCC  :'+oPCC);
            ShipmentInfoComponent oShipmentInfoComponent = new ShipmentInfoComponent(oPCC);
           
            System.debug('This is mComponentId_Shipment_Info_Component.get(oPCC.Component__c) :'+ mComponentId_Shipment_Info_Component.get(oPCC.Component__c));
            
            oShipmentInfoComponent.oComponent = oPCC;
            if(mComponentId_Shipment_Info_Component.get(oPCC.Component__c)!=null)
            {
                oShipmentInfoComponent.isChecked   = true;
                oShipmentInfoComponent.oShipment_Info_Component = mComponentId_Shipment_Info_Component.get(oPCC.Component__c);
            }
            else
            {
                oShipmentInfoComponent.oComponent = oPCC; 
            }
            ShipmentInfoComponents.add(oShipmentInfoComponent);
        }
        system.debug('This ShipmentInfoComponents :'+ShipmentInfoComponents);
       return  ShipmentInfoComponents;
        
    
    }
    public PageReference SaveComponent() {
        update oShipment_Info;
         List<Shipment_Info_Component__c> lstShipment_Info_Component = new List<Shipment_Info_Component__c>();
         List<Shipment_Info_Component__c> lst = oShipment_Info.Shipment_Info_Components__r;
         system.debug('THis is List to be deleted :'+lst);
         if(lst !=null)
         try{
             delete lst;
         }catch(Exception ex){system.debug('This is Exception :'+ex);}
         system.debug('This is ShipmentInfoComponents :'+ShipmentInfoComponents);
        for(ShipmentInfoComponent oShipmentInfoComponent :ShipmentInfoComponents)
        {
            if(oShipmentInfoComponent.isChecked)
            {
                system.debug('oShipmentInfoComponent.oComponent :'+oShipmentInfoComponent.oComponent);
                system.debug('this is oShipmentInfoComponent.oShipment_Info_Component :'+oShipmentInfoComponent.oShipment_Info_Component);
                Shipment_Info_Component__c oSIC = new Shipment_Info_Component__c();
                if(oShipmentInfoComponent.oShipment_Info_Component !=null)
                {
                  system.debug('This is oShipmentInfoComponent.oShipment_Info_Component.Name :'+oShipmentInfoComponent.oShipment_Info_Component.Name);
                  oSIC.Name = oShipmentInfoComponent.oShipment_Info_Component.Name;
                  
                }
                else
                {
                system.debug('This is oShipmentInfoComponent.oComponent.Name :'+oShipmentInfoComponent.oComponent.Name);
                oSIC.Name  = oShipmentInfoComponent.oComponent.Name;
                
                }
                oSIC.Status__c = oShipmentInfoComponent.oShipment_Info_Component.Status__c;
                oSIC.Component__c = oShipmentInfoComponent.oComponent.Component__c;
                oSIC.Quantity__c = oShipmentInfoComponent.oShipment_Info_Component.Quantity__c;
                
                oSIC.Closed__c = oShipmentInfoComponent.oShipment_Info_Component.Closed__c;
                oSIC.Quantity_Received__c = oShipmentInfoComponent.oShipment_Info_Component.Quantity_Received__c;
                oSIC.Shipment_Info__c =  oShipment_Info.Id;
                lstShipment_Info_Component.add(oSIC);
            }
        }
        insert lstShipment_Info_Component;
        
        
        isPageEditable = true;
        //PageReference  oPage = new PageReference('/'+CurrentPageId);
        PageReference  oPage = new PageReference('/apex/vfShippingInfoDetail?Id='+CurrentPageId);
        oPage.setRedirect(true);
        return oPage;
    }
    
    public PageReference SendComponent() {
        Shipment_Info__c ObjShipment_Info = new Shipment_Info__c(id=oShipment_Info.Id);
        ObjShipment_Info.Sent_Info__c = true;
        ObjShipment_Info.Sent_Info_Date__c = system.today();
        update ObjShipment_Info;
        
        //PageReference  oPage = new PageReference('/apex/vfShippingInfoPDF?id='+oShipment_Info.Id);
        //oPage.setRedirect(true);
        return null;
    }

    public PageReference EditShipTo() {
        isPageEditable = false;
        return null;
    }
    
    public PageReference doComponentEdit() {
        isComponentEditable  = false;
        isPageEditable = false;
        return null;
    }
    public PageReference doCancel()
    {
       PageReference  oPage = new PageReference('/'+oShipment_Info.Technician_Assignment__c);
       oPage.setRedirect(true);
       return oPage;
    }
     public PageReference doComponentUpdate() {
         List<Shipment_Info_Component__c> lstShipment_Info_Component = new List<Shipment_Info_Component__c>();
         List<Shipment_Info_Component__c> lst = oShipment_Info.Shipment_Info_Components__r;
         system.debug('THis is List to be deleted :'+lst);
         if(lst !=null)
         try{
             delete lst;
         }catch(Exception ex){system.debug('This is Exception :'+ex);}
         system.debug('This is ShipmentInfoComponents :'+ShipmentInfoComponents);
        for(ShipmentInfoComponent oShipmentInfoComponent :ShipmentInfoComponents)
        {
            if(oShipmentInfoComponent.isChecked)
            {
                system.debug('oShipmentInfoComponent.oComponent :'+oShipmentInfoComponent.oComponent);
                system.debug('this is oShipmentInfoComponent.oShipment_Info_Component :'+oShipmentInfoComponent.oShipment_Info_Component);
                Shipment_Info_Component__c oSIC = new Shipment_Info_Component__c();
                if(oShipmentInfoComponent.oShipment_Info_Component !=null)
                {
                  system.debug('This is oShipmentInfoComponent.oShipment_Info_Component.Name :'+oShipmentInfoComponent.oShipment_Info_Component.Name);
                  oSIC.Name = oShipmentInfoComponent.oShipment_Info_Component.Name;
                  
                }
                else
                {
                system.debug('This is oShipmentInfoComponent.oComponent.Name :'+oShipmentInfoComponent.oComponent.Name);
                oSIC.Name  = oShipmentInfoComponent.oComponent.Name;
                
                }
                oSIC.Status__c = oShipmentInfoComponent.oShipment_Info_Component.Status__c;
                oSIC.Component__c = oShipmentInfoComponent.oComponent.Component__c;
                oSIC.Quantity__c = oShipmentInfoComponent.oShipment_Info_Component.Quantity__c;
                
                oSIC.Closed__c = oShipmentInfoComponent.oShipment_Info_Component.Closed__c;
                oSIC.Quantity_Received__c = oShipmentInfoComponent.oShipment_Info_Component.Quantity_Received__c;
                oSIC.Shipment_Info__c =  oShipment_Info.Id;
                lstShipment_Info_Component.add(oSIC);
            }
        }
        insert lstShipment_Info_Component;
        isComponentEditable  = true;
        isPageEditable = true;
        return null;
    }


    public class ShipmentInfoComponent
    {
        public Shipment_Info_Component__c oShipment_Info_Component {get;set;}
        public Product_Code_Component__c oComponent {get;set;}
        public boolean isChecked {get;set;}
        public ShipmentInfoComponent(Product_Code_Component__c oComp)
        {
             isChecked  = false;
             oComponent =oComp;
             oShipment_Info_Component  = new Shipment_Info_Component__c();
        }
    }
}