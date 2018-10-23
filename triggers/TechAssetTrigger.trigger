/*
 * RelEng Perforce/RCS Header - Do not remove!
 *
 * $Author: mfullmore $
 * $Change: 932534 $
 * $DateTime: 2009/03/18 15:33:46 $
 * $File: //it/applications/supportforce/mar2009/prod/src/triggers/TechAssetTrigger.trigger $
 * $Id: //it/applications/supportforce/mar2009/prod/src/triggers/TechAssetTrigger.trigger#1 $
 * $Revision: #1 $
 */

trigger TechAssetTrigger on Tech_Asset__c (before insert, before update) {
    NetPartCodeBeforeInsert npci;
    NetPartCodeBeforeUpdate npcu;
    if(trigger.isBefore){
        if(trigger.isInsert){
            npci = new NetPartCodeBeforeInsert (trigger.new);
            //TechAssetName tap = new TechAssetName (trigger.new);
        }
        if(trigger.isUpdate){
            npcu = new NetPartCodeBeforeUpdate (trigger.old, trigger.new);
        }
    }
}