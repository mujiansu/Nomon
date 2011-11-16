class SeqAct_NOMSetCollect extends SequenceAction;

var() int NumCoins;
DefaultProperties
	{
	ObjName="Set Coins Needed"
		ObjCategory="Nomon"
	HandlerName="SetCoinsNeeded"
	NumCoins = 0
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int', LinkDesc="NumCoins", bWriteable=true, PropertyName=NumCoins)
}