trigger CaseTrigger on Case (before insert, before update, before delete, 
after insert, after update, after delete, after undelete) {
    //CaseTimeTracking tt = new CaseTimeTracking();
/*
    if(trigger.isAfter){
        if(trigger.isUpdate){
            //tt.afterUpdateProcess(trigger.old, trigger.new);
            WGCaseAfterUpdate cau = new WGCaseAfterUpdate(trigger.old, trigger.new);
        }

        if(trigger.isInsert){
            //tt.NewCaseWorkgroup(trigger.new);
            WGCaseAfterInsert cai = new WGCaseAfterInsert(trigger.new);
        }
        
        if(trigger.isDelete){
            //tt.DeleteCaseTracker(trigger.old);
            WGCaseAfterDelete cad = new WGCaseAfterDelete(trigger.old);
        }
    }
    */
}