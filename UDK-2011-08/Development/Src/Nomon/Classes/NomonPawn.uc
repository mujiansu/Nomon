class NomonPawn extends UDNPawn
    dependson(UDNPawn);
 
//var PhysicsAsset defaultPhysicsAsset;

 
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


//simulated function SetCharacterClassFromInfo(class<UTFamilyInfo> Info)
 //{  Mesh.SetPhysicsAsset(defaultPhysicsAsset);
//}

defaultproperties
{
 ControllerClass=class'Nomon.NomonBot'

// Movement mechanics 	
	JumpZ=650.0 // 128 tall block clear
	MaxJumpHeight=1024.0 // Has to be higher than average to allow us to jump
	MaxStepHeight=50.0
	
	GroundSpeed=350.0
	AirSpeed=350.0 // From 440
	WaterSpeed=220.0
	AccelRate=1024.0 // Not so fast! From 2048
	AirControl=+0.20 //.35 //From 0.05
	SlopeBoostFriction=0.2
	mass = 0.8 // Default 1
	
//Multi Jumping
	bCanDoubleJump=false
	MaxMultiJump=0
	MultiJumpRemaining=0
	MultiJumpBoost=-45.0
	DoubleJumpThreshold=160.0

//Can booleans	
	bCanCrouch=false
	bCanStrafe=false
	bCanClimbLadders=false
	bCanPickupInventory=false
	bStopOnDoubleLanding=false //Slows after duoble jump
	bPushesRigidBodies=true
	
	//bAllowLedgeOverhang=false// Something to look into! //TRUE then allow the pawn to hang off ledges based on the cylinder extent
	//bCanClimbUp = false // For "cover walls"
	
	SoundGroupClass=class'UTGame.UTPawnSoundGroup'
	TransInEffects(0)=class'UTEmit_TransLocateOutRed'
	TransInEffects(1)=class'UTEmit_TransLocateOut'

	SpawnProtectionColor=(R=100,G=100,B=100)
	TranslocateColor[0]=(R=20)
	TranslocateColor[1]=(B=20)
	DamageParameterName=DamageOverlay
	SaturationParameterName=Char_DistSatRangeMultiplier

// Corpse despawn
	RagdollLifespan=0.01
	bPhysRigidBodyOutOfWorldCheck=true
	bRunPhysicsWithNoController=true

	//ControllerClass=class'UTGame.UTBot'

	LeftFootControlName=LeftFootControl
	RightFootControlName=RightFootControl
	bEnableFootPlacement=true
	
//Sounds
	//ArmorHitSound=SoundCue'A_Gameplay.Gameplay.A_Gameplay_ArmorHitCue'
	SpawnSound=SoundCue'A_Ambient_NonLoops.Thunder.Thunder_Distant_Stereo_01_Cue'
	TeleportSound=SoundCue'A_Ambient_NonLoops.Thunder.Thunder_Distant_Stereo_01_Cue'

// Falling
	//MaxFallSpeed=+1250.0 //Fall faster and you die!
	LastPainSound=-1000.0
	TorsoBoneName=b_Spine2
	FallImpactSound=SoundCue'A_Character_BodyImpacts.BodyImpacts.A_Character_BodyImpact_BodyFall_Cue'
	FallSpeedThreshold=125.0

// Moving here for now until we can fix up the code to have it pass in the armor object
	ShieldBeltMaterialInstance=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Overlay'
	ShieldBeltTeamMaterialInstances(0)=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Red'
	ShieldBeltTeamMaterialInstances(1)=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Blue'
	ShieldBeltTeamMaterialInstances(2)=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Red'
	ShieldBeltTeamMaterialInstances(3)=Material'Pickups.Armor_ShieldBelt.M_ShieldBelt_Blue'

	HeroCameraPitch=6000
	HeroCameraScale=6.0

	//@TEXTURECHANGEFIXME - Needs actual UV's for the Player Icon
	IconCoords=(U=657,V=129,UL=68,VL=58)
	MapSize=1.0

	// default bone names
	WeaponSocket=WeaponPoint
	WeaponSocket2=DualWeaponPoint
	HeadBone=b_Head
	PawnEffectSockets[0]=L_JB
	PawnEffectSockets[1]=R_JB

	MinTimeBetweenEmotes=1.0

	DeathHipLinSpring=10000.0
	DeathHipLinDamp=500.0
	DeathHipAngSpring=10000.0
	DeathHipAngDamp=500.0

	bWeaponAttachmentVisible=true

	TransCameraAnim[0]=CameraAnim'Envy_Effects.Camera_Shakes.C_Res_IN_Red'
	TransCameraAnim[1]=CameraAnim'Envy_Effects.Camera_Shakes.C_Res_IN_Blue'
	TransCameraAnim[2]=CameraAnim'Envy_Effects.Camera_Shakes.C_Res_IN'

	SwimmingZOffset=-30.0
	SwimmingZOffsetSpeed=45.0
	

}