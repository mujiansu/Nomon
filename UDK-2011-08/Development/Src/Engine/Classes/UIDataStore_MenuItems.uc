/**
 * This data store provides information for automatically generating lists of widgets
 * given a collection of metadata provided by the UIDataProvider_MenuItem class.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIDataStore_MenuItems extends UIDataStore_GameResource
	native(inherit)
	config(UI);

/**
 * the tag used to retrieve the menu items for the gametype options of the OnlineGameSettings datastore's selected game configuration.
 */
var	const								name				CurrentGameSettingsTag;

/** collection of providers per part type. */
var	const	private	native	transient	MultiMap_Mirror		OptionProviders{TMultiMap<FName, class UUIDataProvider_MenuItem*>};

/** Array of dynamically created providers. */
var transient array<UIDataProvider_MenuItem>				DynamicProviders;

cpptext
{
	/* === UUIDataStore_MenuItems interface === */
	/**
	 * Converts the specified name into the tag required to access the options for the current game settings object,
	 * if the specified field is CurrentGameSettingsTag.  Otherwise, does nothing.
	 *
	 * @param	FieldName	the name of the field that was passed to this data store.
	 *
	 * @return	a tag which can be used to access the settings collection for the current game settings object, or the same
	 *			value as the input value.
	 */
	FName ResolveFieldName( FName FieldName ) const;
	FString ResolveFieldString( const FString& FieldString ) const;

	/**
	 * Called when this data store is added to the data store manager's list of active data stores.
	 *
	 * @param	PlayerOwner		the player that will be associated with this DataStore.  Only relevant if this data store is
	 *							associated with a particular player; NULL if this is a global data store.
	 */
	virtual void OnRegister( ULocalPlayer* PlayerOwner );
}

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
native function GetSet(name SetName, out array<UIDataProvider_MenuItem> OutProviders);

/**
 * Handler for the OnlineGameSettings data store's OnDataProviderPropertyChange delegate.  When the selected gametype is
 * changed, updates the current game option set.
 *
 * @param	SourceProvider	the data provider that generated the notification
 * @param	PropTag			the property that changed
 */
function OnGameSettingsChanged( UIDataProvider SourceProvider, optional name PropTag )
{
	local UIDataStore_OnlineGameSettings GameSettingsDataStore;

	GameSettingsDataStore = UIDataStore_OnlineGameSettings(SourceProvider);
	if ( GameSettingsDataStore != None && PropTag == 'SelectedIndex' )
	{
		RefreshSubscribers(CurrentGameSettingsTag, true, Self);
	}
}

/* === UIDataStore interface === */
/**
 * Called when this data store is added to the data store manager's list of active data stores.
 *
 * @param	PlayerOwner		the player that will be associated with this DataStore.  Only relevant if this data store is
 *							associated with a particular player; NULL if this is a global data store.
 */
event Registered( LocalPlayer PlayerOwner )
{
	Super.Registered(PlayerOwner);
}

/**
 * Called when this data store is removed from the data store manager's list of active data stores.
 *
 * @param	PlayerOwner		the player that will be associated with this DataStore.  Only relevant if this data store is
 *							associated with a particular player; NULL if this is a global data store.
 */
event Unregistered( LocalPlayer PlayerOwner )
{
	Super.Unregistered(PlayerOwner);
}

DefaultProperties
{
	Tag=MenuItems

	CurrentGameSettingsTag=CurrentGameSettings
}


