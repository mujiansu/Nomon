class NomonPlayerController extends UDNPlayerController
    dependson(UDNPlayerController)
    	dependson(SeqAct_NOMPoints)
        dependson(SeqAct_NOMSetCollect)
        dependson(SeqAct_NOMCollect)
		dependson(NomonPlayerReplicationInfo);
var() int NOMPoints;
var() int NOMCollected;
var() int NOMNeededThisLevel;

exec function TestWinningConditions()
{
   local int i;
   local Sequence GameSeq;
   local array<SequenceObject> AllSeqEvents;
 
  `log("TestWinningConditions() : Checking winning conditions");
  `log("TestWinningConditions() : Collected: "$NOMCollected);
  `log("TestWinningConditions() : Needed: "$NOMNeededThisLevel);
 
  if(NOMCollected > 0 && NOMNeededThisLevel > 0 && NOMCollected >= NOMNeededThisLevel)
  {
       `log("TestWinningConditions() : Victory!");
       GameSeq = WorldInfo.GetGameSequence();
 
       if(GameSeq != None)
       {
               GameSeq.FindSeqObjectsByClass(class'SeqEvent_NOMGameWon', true, AllSeqEvents);
               for(i=0; i<AllSeqEvents.Length; i++)
                       SeqEvent_NOMGameWon(AllSeqEvents[i]).CheckActivate(WorldInfo, None);
       }
  }
  else
  {
       `log("TestWinningConditions() : Go collect more coins!");
  }
}
function CollectCoin(SeqAct_NOMCollect MyAction)
{
  `log("CollectCoin() : Collected coin");
  NOMCollected += 1;
  TestWinningConditions();
}
function SetCoinsNeeded(SeqAct_NOMSetCollect MyAction)
{
  `log("SetCoinsNeeded() : Set needed coins to "$MyAction.NumCoins);
  NOMNeededThisLevel = MyAction.NumCoins;
}
function AddPoints(SeqAct_NOMPoints MyAction)
{
  `log("AddPoints() : Adding points: "$MyAction.NumPoints);
  NOMPoints += MyAction.NumPoints;
}

defaultproperties
{
  NOMPoints = 0
  NOMCollected = 0
  NOMNeededThisLevel = 1
  
}