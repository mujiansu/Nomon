/**
 * Provides a general purpose global storage area for game or configuration data.
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIDataStore_Registry extends UIDataStore
	native(inherit);

cpptext
{
	/* === UIDataStore interface === */
	/**
	 * Creates the data provider for this registry data store.
	 */
	virtual void InitializeDataStore();

	/* === UIDataProvider interface === */
protected:


public:

	/**
	 * Returns a pointer to the data provider which provides the tags for this data provider.  Normally, that will be this data provider,
	 * but in this data store, the data fields are pulled from an internal provider but presented as though they are fields of the data store itself.
	 */
	virtual UUIDataProvider* GetDefaultDataProvider();

	/**
	 * Notifies the data store that all values bound to this data store in the current scene have been saved.  Provides data stores which
	 * perform buffered or batched data transactions with a way to determine when the UI system has finished writing data to the data store.
	 */
	virtual void OnCommit();
}

struct KeyValuePair
{
	var string Key;
	var string Value;
};


/**
 * The data fields which have been added to this data store.
 */
var	array<KeyValuePair> RegistryData;

/**
 * Get data from the RegistryData array
 * @param Key - The key to get data for
 * @param out_Data - the data that was recovered
 *
 * @return True if there was data to recover, false if there was no data for the specified key
 */
event bool GetData(string Key, out string out_Data)
{
	local int i;

	for (i = 0; i < RegistryData.length; i++)
	{
		if (RegistryData[i].Key == Key)
		{
			out_Data = RegistryData[i].Value;
			return true;
		}
	}
	return false;
}

/**
 * Set data to the RegistryData array
 * @param Key - The key to set data for
 * @param Value - the data that is to be stored
 */
event SetData(string Key, string Value)
{
	local int i;
	local KeyValuePair KVP;

	for (i = 0; i < RegistryData.length; i++)
	{
		if (RegistryData[i].Key == Key)
		{
			RegistryData[i].Value = Value;
			return;
		}
	}
	
	KVP.Key = Key;
	KVP.Value = Value;

	RegistryData.AddItem(KVP);
}


DefaultProperties
{
	Tag=Registry
}


