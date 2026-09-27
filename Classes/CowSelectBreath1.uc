//=============================================================================
// CowSelectBreath1.
//=============================================================================
class CowSelectBreath1 extends Effects ;

#exec MESH IMPORT MESH=JRMCowSelectMesh ANIVFILE=Models\CowSelectBreath1_a.3d DATAFILE=Models\CowSelectBreath1_d.3d X=0 Y=0 Z=0 LODSTYLE=10 LODFRAME=0 
#exec MESH ORIGIN MESH=JRMCowSelectMesh X=0 Y=0 Z=0 YAW=-64 PITCH=0 ROLL=0

#exec MESH SEQUENCE MESH=JRMCowSelectMesh SEQ=Breath1    STARTFRAME=0 NUMFRAMES=271 RATE=24
#exec MESH SEQUENCE MESH=JRMCowSelectMesh SEQ=Breath2    STARTFRAME=0 NUMFRAMES=271 RATE=24
#exec MESH SEQUENCE MESH=JRMCowSelectMesh SEQ=Still    STARTFRAME=0 NUMFRAMES=3 RATE=24

#exec MESHMAP NEW MESHMAP=JRMCowSelectMesh MESH=JRMCowSelectMesh
//#exec MESHMAP SCALE MESHMAP=Cow X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SCALE MESHMAP=JRMCowSelectMesh X=0.063 Y=0.0432  Z=0.126
/*
#exec TEXTURE IMPORT NAME=Texture FILE=Textures\Texture.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SETTEXTURE MESHMAP=Cow NUM=0 TEXTURE=Texture

#exec TEXTURE IMPORT NAME=Texture FILE=Textures\Texture.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SETTEXTURE MESHMAP=Cow NUM=1 TEXTURE=Texture

#exec TEXTURE IMPORT NAME=Texture FILE=Textures\Texture.PCX GROUP=Skins FLAGS=2
#exec MESHMAP SETTEXTURE MESHMAP=Cow NUM=2 TEXTURE=Texture
*/
function PostBeginPlay()
{
	
	LoopAnim('Breath1', 1.0, 0.1);
}


defaultproperties
{
    DrawType=DT_Mesh
    Mesh=JRMCowSelectMesh
	bStatic=False
	bNoDelete=True
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy
}