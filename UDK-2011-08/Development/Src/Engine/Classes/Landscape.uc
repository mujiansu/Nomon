/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class Landscape extends LandscapeProxy
	dependson(LightComponent)
	native(Terrain)
	hidecategories(LandscapeProxy)
	showcategories(Display, Movement, Collision, Lighting);

/** Max LOD level to use when rendering */
var() int MaxLODLevel;

/** Default physical material, used when no per-layer values physical materials */
var() PhysicalMaterial DefaultPhysMaterial;

/** Layers that can be painted on the landscape */
var deprecated array<Name> LayerNames;

/** Structure storing Layer Data */
struct native LandscapeLayerInfo
{
	var() Name LayerName;
	// Used to erosion caculation?
	var() float Hardness;
	var bool bNoWeightBlend;
	var transient bool bSelected;
	var() PhysicalMaterial PhysMaterial;
	var editoronly MaterialInstanceConstant ThumbnailMIC;
	var editoronly int DebugColorChannel;

	structcpptext
	{
		// tor
		FLandscapeLayerInfo(FName InName, FLOAT InHardness=0.5f, UBOOL InNoWeightBlend=FALSE)
		:	LayerName(InName)
		,	Hardness(InHardness)
		,	bNoWeightBlend(InNoWeightBlend)
		,	bSelected(FALSE)
		,	PhysMaterial(NULL)
#if WITH_EDITORONLY_DATA
		,	ThumbnailMIC(NULL)
		,	DebugColorChannel(0)
#endif // WITH_EDITORONLY_DATA
		{}

		// for TArray::FindItemIndexByKey
		UBOOL operator==( const FLandscapeLayerInfo& Other ) const
		{
			return LayerName == Other.LayerName;
		}
	}
};

/** Structure storing Collision for LandscapeComponent Add */
struct native LandscapeAddCollision
{
	var editoronly vector Corners[4];
	structcpptext
	{
		FLandscapeAddCollision()
		{
#if WITH_EDITORONLY_DATA
			Corners[0] = Corners[1] = Corners[2] = Corners[3] = FVector(0.f, 0.f, 0.f);
#endif // WITH_EDITORONLY_DATA
		}
	}
};

var array<LandscapeLayerInfo> LayerInfos;

/** The Lightmass settings for this object. */
var(Lightmass) LightmassPrimitiveSettings	LightmassSettings <ScriptOrder=true>;

/**
 * Allows artists to adjust the distance where textures using UV 0 are streamed in/out.
 * 1.0 is the default, whereas a higher value increases the streamed-in resolution.
 */
var() const float	StreamingDistanceMultiplier;

/** The array of LandscapeComponent that are used by the landscape */
//var const array<LandscapeComponent>	LandscapeComponents;

/** Array of LandscapeHeightfieldCollisionComponent */
//var const array<LandscapeHeightfieldCollisionComponent>	CollisionComponents;

/** Map of the SectionBaseX/Y component offets (in heightmap space) to the component. Valid in editor only. */
var const native map{QWORD,class ULandscapeComponent*} XYtoComponentMap;

/** Map of the SectionBaseX/Y component offets (in heightmap space) to the collison components. Valid in editor only. */
var const native map{QWORD,class ULandscapeHeightfieldCollisionComponent*} XYtoCollisionComponentMap;

/** Map of the SectionBaseX/Y component offets to the newly added collison components. Only available near valid LandscapeComponents. Valid in editor only. */
var const native map{QWORD,struct FLandscapeAddCollision} XYtoAddCollisionMap;

var const native pointer DataInterface{struct FLandscapeDataInterface};

/** Data set at creation time */
var const int ComponentSizeQuads;		// Total number of quads in each component
var const int SubsectionSizeQuads;		// Number of quads for a subsection of a component. SubsectionSizeQuads+1 must be a power of two.
var const int NumSubsections;			// Number of subsections in X and Y axis

var const private native transient Set_Mirror Proxies{TSet<ALandscapeProxy*>};

var const private native Set_Mirror SelectedComponents{TSet<class ULandscapeComponent*>};
var const private native Set_Mirror SelectedCollisionComponents{TSet<class ULandscapeHeightfieldCollisionComponent*>};
var const private native Set_Mirror SelectedRegionComponents{TSet<class ULandscapeComponent*>};

var const private native map{QWORD,FLOAT} SelectedRegion;

cpptext
{
	// Make a key for XYtoComponentMap
	static QWORD MakeKey( INT X, INT Y ) { return ((QWORD)(*(DWORD*)(&X)) << 32) | (*(DWORD*)(&Y) & 0xffffffff); }
	static void UnpackKey( QWORD Key, INT& OutX, INT& OutY ) { *(DWORD*)(&OutX) = (Key >> 32); *(DWORD*)(&OutY) = Key&0xffffffff; }

	virtual class ALandscape* GetLandscapeActor();
	virtual void ClearComponents();

	virtual void ClearCrossLevelReferences();
#if WITH_EDITOR
	virtual void PreSave();
	virtual void UpdateComponentsInternal(UBOOL bCollisionUpdate = FALSE);

	virtual UBOOL GetSelectedComponents(TArray<UObject*>& SelectedObjects);

	// ALandscape interface
	UBOOL ImportFromOldTerrain(class ATerrain* OldTerrain);
	void Import(INT VertsX, INT VertsY, INT ComponentSizeQuads, INT NumSubsections, INT SubsectionSizeQuads, WORD* HeightData, TArray<FLandscapeLayerInfo> ImportLayerInfos, BYTE* AlphaDataPointers[] );
	struct FLandscapeDataInterface* GetDataInterface();
	void GetComponentsInRegion(INT X1, INT Y1, INT X2, INT Y2, TSet<ULandscapeComponent*>& OutComponents);
	UBOOL GetLandscapeExtent(INT& MinX, INT& MinY, INT& MaxX, INT& MaxY);
	UBOOL GetSelectedExtent(INT& MinX, INT& MinY, INT& MaxX, INT& MaxY);
	FVector GetLandscapeCenterPos(FLOAT& LengthZ, INT MinX = MAXINT, INT MinY = MAXINT, INT MaxX = MININT, INT MaxY = MININT);
	UBOOL IsValidPosition(INT X, INT Y);
	void Export(TArray<FString>& Filenames);
	void DeleteLayer(FName LayerName);

	void UpdateDebugColorMaterial();

	void GetAllEditableComponents(TArray<ULandscapeComponent*>* AllLandscapeComponnents, TArray<ULandscapeHeightfieldCollisionComponent*>* AllCollisionComponnents = NULL);

	virtual UMaterialInterface* GetLandscapeMaterial() const;
	UBOOL HasAllComponent(); // determine all component is in this actor

	// UObject interface
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostEditChangeChainProperty(FPropertyChangedChainEvent& PropertyChangedEvent);
	virtual void PostEditMove(UBOOL bFinished);

	// Include Components with overlapped vertices
	static void CalcComponentIndicesOverlap(const INT X1, const INT Y1, const INT X2, const INT Y2, const INT ComponentSizeQuads, 
		INT& ComponentIndexX1, INT& ComponentIndexY1, INT& ComponentIndexX2, INT& ComponentIndexY2);

	// Exclude Components with overlapped vertices
	static void CalcComponentIndices(const INT X1, const INT Y1, const INT X2, const INT Y2, const INT ComponentSizeQuads, 
		INT& ComponentIndexX1, INT& ComponentIndexY1, INT& ComponentIndexX2, INT& ComponentIndexY2);

	static void SplitHeightmap(ULandscapeComponent* Comp, UBOOL bMoveToCurrentLevel = FALSE);

	// Used by all selection tool...
	void UpdateSelectedComponents(TSet<class ULandscapeComponent*>& NewComponents, UBOOL bIsComponentwise = TRUE);
	// Sort selected components based on location
	void SortSelectedComponents();
	void ClearSelectedRegion(UBOOL bIsComponentwise = TRUE);

	// Update Collision object for add LandscapeComponent tool
	void UpdateAllAddCollisions();
	void UpdateAddCollision(QWORD LandscapeKey, UBOOL bForceUpdate = FALSE);

	void ChangedPhysMaterial();

	/**
	 * Function that gets called from within Map_Check to allow this actor to check itself
	 * for any potential errors and register them with map check dialog.
	 */
	virtual void CheckForErrors();
#endif
	virtual void Serialize(FArchive& Ar);
	virtual void BeginDestroy();
	virtual void PostLoad();
}

defaultproperties
{
	Begin Object Name=Sprite
		Sprite=Texture2D'EditorResources.S_Terrain'
		SpriteCategoryName="Landscape"
	End Object

	DrawScale3D=(X=128.0,Y=128.0,Z=256.0)
	bEdShouldSnap=True
	bCollideActors=True
	bBlockActors=True
	bWorldGeometry=True
	bStatic=True
	bNoDelete=True
	bHidden=False
	bMovable=False
	StaticLightingResolution=1.0
	StreamingDistanceMultiplier=1.0
	MaxLODLevel=-1
	bIsProxy=False
}
 