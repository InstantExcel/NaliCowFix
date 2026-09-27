//=============================================================================
// TCow.
//=============================================================================
class JRMCowPlayer extends CustomPlayer;


simulated function SetMyMesh()
{
	Super.SetMyMesh();
	bIsMultiSkinned = true;
}

static function SetMyMultiSkin(Actor SkinActor, string SkinName, string FaceName, byte TeamNum)
{

	// Run standard SetMultiSkin...

	SetMultiSkin(SkinActor, SkinName, FaceName, TeamNum);
}

static function SetMultiSkin(Actor SkinActor, string SkinName, string FaceName, byte TeamNum)
{


	local string SkinItem, FaceItem, SkinPackage, FacePackage;



	// 1. Sanitize SkinName
	if ( SkinName == "" )
		SkinName = default.DefaultSkinName;

	SkinItem = SkinActor.GetItemName(SkinName);
	SkinPackage = Left(SkinName, Len(SkinName) - Len(SkinItem));

	if ( SkinPackage == "" || SkinPackage == "None." )
		SkinPackage = default.DefaultCustomPackage;

	// Strip trailing '1' if UT99 passed WARC1 or ATMC1
	if ( Right(SkinItem, 1) == "1" )
		SkinItem = Left(SkinItem, Len(SkinItem) - 1);

	// 2. Sanitize FaceName
	if ( FaceName == "" )
		FaceName = default.DefaultFace;

	FaceItem = SkinActor.GetItemName(FaceName);
	FacePackage = Left(FaceName, Len(FaceName) - Len(FaceItem));

	if ( FacePackage == "" || FacePackage == "None." )
		FacePackage = default.DefaultCustomPackage;

	
	log("=========================================");
	log(":: STUFF -  P L A Y E R :: ");
	log("Selected Class  : "	$ SkinActor.Class);
	log("Passed SkinName : '"	$ SkinName $ "'");
	log("FacePackage  : "		$FaceItem ) ;
	log("FaceName  : "			$ FaceName);
	log("SkinPackage  : "		$ SkinPackage);
	log("SkinItem  : "			$ SkinItem);
	log("Passed FaceName : '"	$ FaceName $ "'");
	log("Passed TeamNum  : "	$ TeamNum);
	log("Mesh Assigned   : "	$ SkinActor.Mesh);
	log("=========================================");



	// :: 0 Body - Skin ::
	SetSkinElement(SkinActor, 0, SkinPackage $ SkinItem $ "0", default.DefaultCustomPackage $ "ATMC0");

	// :: 1 Backpack  - Team + Skin ::
	if( TeamNum < 4 )
		SetSkinElement(SkinActor, 1, SkinPackage $ SkinItem $ "1T_" $ String(TeamNum), SkinPackage $ SkinItem $ "1");
	else
		SetSkinElement(SkinActor, 1, SkinPackage $ SkinItem $ "1", default.DefaultCustomPackage $ "ATMC1");

	// :: 2 Head  -  Skin + Face ::
	SetSkinElement(SkinActor, 2, SkinPackage $ SkinItem $ "2" $ FaceItem, default.DefaultCustomPackage $ "ATMC2DEFAULT");

	// :: 5 Chat  -  Skin + Face :: 
	if( Pawn(SkinActor) != None )
	{
		Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject(SkinPackage $ SkinItem $ "5" $ FaceItem, class'Texture'));
		
		if ( Pawn(SkinActor).PlayerReplicationInfo.TalkTexture == None )
			Pawn(SkinActor).PlayerReplicationInfo.TalkTexture = Texture(DynamicLoadObject(default.DefaultCustomPackage $ "ATMC5DEFAULT", class'Texture'));
	}
}


// :: Cow anim overrides... 
function PlayDying(name DamageType, vector HitLoc)
{
	if ( Mesh == FallBackMesh )
	{
		Super.PlayDying(DamageType, HitLoc);
		return;
	}
	BaseEyeHeight = Default.BaseEyeHeight;
	PlayDyingSound();
			
	if ( DamageType == 'Suicided' )
	{
		PlayAnim('Dead2',, 0.1);
		return;
	}

	// check for head hit
	if ( DamageType == 'Decapitated' )
	{
		PlayCowDecap();
		return;
	}

	// check for big hit
	if ( Velocity.Z > 200 )
	{
		PlayAnim('Dead3',,0.1);
		return;
	}

	if ( HitLoc.Z - Location.Z > 0.7 * CollisionHeight )
	{
		PlayAnim('Dead2',, 0.1);
		return;
	}
	
	PlayAnim('Dead1',, 0.1);
}

function PlayCowDecap()
{
	local carcass carc;

	if ( class'GameInfo'.Default.bVeryLowGore )
	{
		PlayAnim('Dead2',, 0.1);
		return;
	}

	PlayAnim('Dead4',, 0.1);
	if ( Level.NetMode != NM_Client )
	{
		carc = Spawn(class 'TCowHead',,, Location + CollisionHeight * vect(0,0,0.8), Rotation + rot(3000,0,16384) );
		if (carc != None)
		{
			carc.Initfor(self);
			carc.RemoteRole = ROLE_SimulatedProxy;
			carc.Velocity = Velocity + VSize(Velocity) * VRand();
			carc.Velocity.Z = FMax(carc.Velocity.Z, Velocity.Z);
		}
	}
}

defaultproperties
{



	CarcassType=Class'tcowcarcass'
	drown=Sound'UnrealShare.Male.MDrown1'
	breathagain=Sound'UnrealShare.Nali.cough1n'
	Footstep1=Sound'UnrealShare.Cow.walkC'
	Footstep2=Sound'UnrealShare.Cow.walkC'
	Footstep3=Sound'UnrealShare.Cow.walkC'
	HitSound3=Sound'UnrealShare.Cow.injurC1c'
	HitSound4=Sound'UnrealShare.Cow.cMoo2c'
	Deaths(0)=Sound'UnrealShare.Cow.DeathC1c'
	Deaths(1)=Sound'UnrealShare.Cow.DeathC1c'
	Deaths(2)=Sound'UnrealShare.Cow.DeathC1c'
	Deaths(3)=Sound'UnrealShare.Cow.DeathC1c'
	Deaths(4)=Sound'UnrealShare.Cow.cMoo2c'
	Deaths(5)=Sound'UnrealShare.Cow.cMoo2c'
	GaspSound=Sound'UnrealShare.Nali.breath1n'
	UWHit1=Sound'UnrealShare.Male.MUWHit1'
	UWHit2=Sound'UnrealShare.Male.MUWHit2'
	LandGrunt=Sound'UnrealShare.Male.lland01'
	JumpSound=Sound'UnrealShare.Male.MJump1'
	HitSound1=Sound'UnrealShare.Cow.injurC1c'
	HitSound2=Sound'UnrealShare.Cow.injurC2c'
	MenuName="Nali Cow Fixed"
	VoiceType="MultiMesh.CowVoice"
	Mesh=LodMesh'CowFixJRM26.TCowNewJRM'
	SelectionMesh='CowFixJRM26.TCowNewJRM'


	StatusDoll=Texture'CowFixJRM26.HUD.CowStatusDoll'
    StatusBelt=Texture'CowFixJRM26.HUD.CowBelt'


	  DefaultSkinName="ATMC"
      DefaultPackage="CowFixJRM26Skins."
	  DefaultCustomPackage="CowFixJRM26Skins."
      DefaultFace="Default"
      TeamSkin="ATMC1T_"

      DefaultFace="Default"
      bIsMultiSkinned=True
	
	  FixedSkin=0
	  TeamSkin1=1
	  FaceSkin=2
}