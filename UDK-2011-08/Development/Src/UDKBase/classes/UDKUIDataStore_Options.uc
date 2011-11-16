/**
 * Inherited version of the game resource datastore that exposes sets of options to the UI.
 * These option sets are then used to autogenerate widgets.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UDKUIDataStore_Options extends UIDataStore_GameResource
	native
	Config(Game);

cpptext
{
	/**
	 * Called when this data store is added to the data store manager's list of active data stores.
	 *
	 * @param	PlayerOwner		the player that will be associated with this DataStore.  Only relevant if this data store is
	 *							associated with a particular player; NULL if this is a global data store.
	 */
	virtual void OnRegister( ULocalPlayer* PlayerOwner );
}

/** collection of providers per part type. */
var	const	private	native	transient	MultiMap_Mirror		OptionProviders{TMultiMap<FName, class UUDKUIResourceDataProvider*>};

/** Array of dynamic providers. */
var transient array<UDKUIResourceDataProvider> DynamicProviders;

/**
 * Clears all options in the specified set.
 *
 * @param SetName		Set to clear
 */
native function ClearSet(name SetName);

/**
 * Appends N amount of providers to the specified set.
 *
 * @param SetName		Set to append to
 * @param NumOptions	Number of options to append
 */
native function AppendToSet(name SetName, int NumOptions);

/**
 * Retrieves a set of option providers.
 *
 * @param SetName		Set to retrieve
 * @param OutProviders	Storage array for resulting providers.
 *
 */
native function GetSet(name SetName, out array<UDKUIResourceDataProvider> OutProviders);


DefaultProperties
{
	Tag=UTOptions
}


