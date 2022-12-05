trigger Opportunity_trg on Opportunity (before insert,before update) {
    //OppTrgHandler.updateTrigger(Trigger.NEW);
    List<Opportunity>lstOp=Opportunity_Trg_Handler.UpdateTrgHandler(Trigger.NEW); 
}