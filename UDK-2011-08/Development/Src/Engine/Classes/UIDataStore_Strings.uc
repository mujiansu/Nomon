/**
 * This datastore provides the UI with access to localized strings.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIDataStore_Strings extends UIDataStore_StringBase
	native(inherit)
	transient;

/** list of data providers for each loc file */
var		transient		array<UIConfigFileProvider>		LocFileProviders;

cpptext
{
protected:
	/* === UUIDataStore_Strings interface === */
	/**
	 * Creates an UIConfigFileProvider instance for the loc file specified by FilePathName.
	 *
	 * @return	a pointer to a newly allocated UUIConfigFileProvider instance that contains the data for the specified
	 *			loc file.
	 */
	class UUIConfigFileProvider* CreateLocProvider( const FFilename& FilePathName );

public:
	/* === UIDataStore interface === */
	/**
	 * Loads all .int files and creates UIConfigProviders for each loc file that was loaded.
	 */
	virtual void InitializeDataStore();



	/**
	 * Parses the data store reference and resolves it into a value that can be used by the UI.
	 *
	 * @param	MarkupString	a markup string that can be resolved to a data field contained by this data provider, or one of its
	 *							internal data providers.
	 * @param	out_FieldValue	receives the value of the data field resolved from MarkupString.  If the specified property corresponds
	 *							to a value that can be rendered as a string, the field value should be assigned to the StringValue member;
	 *							if the specified property corresponds to a value that can only be rendered as an image, such as an object
	 *							or image reference, the field value should be assigned to the ImageValue member.
	 *							Data stores can optionally manually create a UIStringNode_Text or UIStringNode_Image containing the appropriate
	 *							value, in order to have greater control over how the string node is initialized.  Generally, this is not necessary.
	 *
	 * @return	TRUE if this data store (or one of its internal data providers) successfully resolved the string specified into a data field
	 *			and assigned the value to the out_FieldValue parameter; false if this data store could not resolve the markup string specified.
	 */
	virtual UBOOL GetDataStoreValue( const FString& MarkupString, struct FUIProviderFieldValue& out_FieldValue )
	{
		return FALSE;
	}

}

DefaultProperties
{
	Tag=Strings
}
