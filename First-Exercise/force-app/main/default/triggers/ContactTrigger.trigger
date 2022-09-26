trigger ContactTrigger on Contact (before insert, before update, after insert, after update) {
    
    if (Trigger.isBefore) {
        
        if (Trigger.isInsert || Trigger.isUpdate) {
         
            ContactTriggerHandler.handleBefore(Trigger.new);
        }
    }
    else if (Trigger.isAfter) {

        if (Trigger.isInsert) {
            
            ContactTriggerHandler.handleAfterInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {

            ContactTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}