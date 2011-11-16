class SeqEvent_NOMGameWon extends SequenceEvent;
 
event Activated(){
       `log("IN SeqEvent_NOMGameWon Activated()");
}
 
defaultproperties
{
    ObjName="Nomon Game Won"
    ObjCategory="Nomon"
        bPlayerOnly = false
}