class SeqAct_NOMPoints extends SequenceAction;

var() int NumPoints;
DefaultProperties
	{
	ObjName="Add Points"
		ObjCategory="Nomon"
	HandlerName="AddPoints"
	NumPoints = 0
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int', LinkDesc="NumPoints", bWriteable=true, PropertyName=NumPoints)
}