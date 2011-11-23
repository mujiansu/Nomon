class NomonPawn extends UDNPawn
    dependson(UDNPawn);
 
simulated function Tick(float DeltaTime)
{
        local vector tmpLocation;
    super.Tick(DeltaTime);
        tmpLocation = Location;
        tmpLocation.Y = 500;
        SetLocation(tmpLocation);
}
 
function bool Dodge(eDoubleClickDir DoubleClickMove)
{
  return false;
}

defaultproperties
{
 ControllerClass=class'Nomon.NomonBot'
 bCanStrafe=false
 MaxStepHeight=50.0
 MaxJumpHeight=128
 JumpZ=550
 //Removes Double Jump
 MaxMultiJump =0
}