trigger trgCaseObject on Case (before insert,before update) {
    Set<Id> sAssertIDs = new Set<Id>();
    Map<Id,Id> mAssetId_SerialNumberID = new Map<Id,Id>();
    for(Case oCase : Trigger.New)
    {
        if(Trigger.isInsert)
        {
            if(oCase.Asset__c  != null && oCase.Serial_Number__c == null)
            {
                sAssertIDs.add(oCase.Asset__c);
            }
        }
        if(Trigger.isUpdate)
        {
            System.debug('This is oCase.AssetID :'+oCase.Asset__c );
            System.debug('This is Trigger.OldMap.get(oCase.Id).Asset__c :'+Trigger.OldMap.get(oCase.Id).AssetId);
            if(oCase.Asset__c != Trigger.OldMap.get(oCase.Id).Asset__c && oCase.Serial_Number__c == null)
            {
                sAssertIDs.add(oCase.Asset__c );
            }
        }
    }
    System.debug('This is sAssertIDs :'+sAssertIDs);
    for(Asset oAsset  :[Select Id,
                               Serial_Number__c 
                        from Asset Where Id IN :sAssertIDs])
    {
        mAssetId_SerialNumberID.put(oAsset.Id,oAsset.Serial_Number__c); 
    }
    System.debug('This is mAssetId_SerialNumberID :'+mAssetId_SerialNumberID);
    for(Case oCase : Trigger.New)
    {
        if(Trigger.isInsert)
        {
            if(oCase.Asset != null && oCase.Serial_Number__c == null)
            {
                oCase.Serial_Number__c = mAssetId_SerialNumberID.get(oCase.AssetId);
            }
        }
        if(Trigger.isUpdate)
        {
            if(oCase.Asset__c  != Trigger.OldMap.get(oCase.Id).Asset__c && oCase.Serial_Number__c == null)
            {
                oCase.Serial_Number__c =mAssetId_SerialNumberID.get(oCase.Asset__c);
                System.debug('Updated Case :'+oCase);
            }
        }
    }

}