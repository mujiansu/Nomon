/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class is responsible for mapping properties in an Settings
 * object to something that the UI system can consume.
 */
class UIDataProvider_Settings extends UIDynamicDataProvider
	native(inherit)
	transient;

/** Holds the settings object that will be exposed to the UI */
var Settings Settings;

/** Keeps a list of providers for each settings id */
struct native SettingsArrayProvider
{
	/** The settings id that this provider is for */
	var int SettingsId;
	/** Cached to avoid extra look ups */
	var name SettingsName;
	/** The provider object to expose the data with */
	var UIDataProvider_SettingsArray Provider;
};

/** The list of mappings from settings id to their provider */
var array<SettingsArrayProvider> SettingsArrayProviders;

/** Whether this provider is a row in a list (removes array handling) */
var bool bIsAListRow;

cpptext
{
	/**
	 * Binds the new settings object to this provider. Sets the type to instance
	 *
	 * @param NewSettings the new object to bind
	 * @param bIsInList whether to use list handling or not
	 *
	 * @return TRUE if bound ok, FALSE otherwise
	 */
	UBOOL BindSettings(USettings* NewSettings,UBOOL bIsInList = FALSE);
}

/**
 * Called when a setting or property which is bound to one of our array providers is updated.
 *
 * @param	SourceProvider		the data provider that generated the notification
 * @param	PropTag				the property that changed
 */
function ArrayProviderPropertyChanged( UIDataProvider SourceProvider, optional name PropTag )
{
}


/**
 * Handler for the OnDataProviderPropertyChange delegate in our internal array providers.  Determines which provider sent the update
 * and propagates that update to this provider's own list of listeners.
 *
 * @param	SettingName		the name of the setting that was changed.
 */
function OnSettingValueUpdated( name SettingName )
{
	local int ProviderIdx;
	local UIDataProvider_SettingsArray ArrayProvider;

	if ( !bIsAListRow )
	{
		for ( ProviderIdx = 0; ProviderIdx < SettingsArrayProviders.Length; ProviderIdx++ )
		{
			if ( SettingName == SettingsArrayProviders[ProviderIdx].SettingsName )
			{
				ArrayProvider = SettingsArrayProviders[ProviderIdx].Provider;
				ArrayProviderPropertyChanged(ArrayProvider, SettingName);
				break;
			}
		}
	}
}

defaultproperties
{
}
