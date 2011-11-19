class UDNPawn extends UTPawn;

var float CamOffsetDistance; //Position on Y-axis to lock camera to

var float oldLocX;
var float oldLocZ;
var float tweenAmount;
var float zoomAmount;
var float camDelta;

//override to make player mesh visible by default
simulated event BecomeViewTarget( PlayerController PC )
{
   local UTPlayerController UTPC;

   Super.BecomeViewTarget(PC);

   if (LocalPlayer(PC.Player) != None)
   {
      UTPC = UTPlayerController(PC);
      if (UTPC != None)
      {
         //set player controller to behind view and make mesh visible
         UTPC.SetBehindView(true);
         SetMeshVisibility(UTPC.bBehindView);
         UTPC.bNoCrosshair = true;
      }
   }
}

simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
   //out_CamLoc = Location;
   out_CamLoc.X = (oldLocX * fDeltaTime * tweenAmount+ Location.X) / (fDeltaTime * tweenAmount+1);
   out_CamLoc.Z = (oldLocZ * fDeltaTime  * tweenAmount+ Location.Z) / (fDeltaTime * tweenAmount+1);
   camDelta = Sqrt((oldLocX-out_CamLoc.X)*(oldLocX-out_CamLoc.X) + (oldLocZ-out_CamLoc.Z)*(oldLocZ-out_CamLoc.Z));
   oldLocX = out_CamLoc.X;
   oldLocZ = out_CamLoc.Z;
   out_CamLoc.Y = CamOffsetDistance-camDelta*zoomAmount* fDeltaTime;
   out_CamLoc.Z +=250;

   out_CamRot.Pitch = -3500;
   out_CamRot.Yaw = 16384;
   out_CamRot.Roll = 0;
   return true;
}

simulated singular event Rotator GetBaseAimRotation()
{
   local rotator   POVRot;

   POVRot = Rotation;
   if( (Rotation.Yaw % 65535 > 16384 && Rotation.Yaw % 65535 < 49560) ||
      (Rotation.Yaw % 65535 < -16384 && Rotation.Yaw % 65535 > -49560) )
   {
      POVRot.Yaw = 32768;
   }
   else
   {
      POVRot.Yaw = 0;
   }
   
   if( POVRot.Pitch == 0 )
   {
      POVRot.Pitch = RemoteViewPitch << 8;
   }

   return POVRot;
}   

defaultproperties
{
   oldLocX = 0;
   oldLocZ = 0;
   CamOffsetDistance=-160.0;
   tweenAmount = 600;
   zoomAmount = 400;
}