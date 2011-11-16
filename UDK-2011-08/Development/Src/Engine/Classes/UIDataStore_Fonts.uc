/**
 * This data store class is responsible for parsing and applying inline font changes.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIDataStore_Fonts extends UIDataStore
	native(inherit);

cpptext
{


	/**
	 * This data store cannot generate string nodes.
	 */
	virtual UBOOL GetDataStoreValue( const FString& MarkupString, struct FUIProviderFieldValue& out_FieldValue ) { return FALSE; }
}

DefaultProperties
{
	Tag=Fonts
}
