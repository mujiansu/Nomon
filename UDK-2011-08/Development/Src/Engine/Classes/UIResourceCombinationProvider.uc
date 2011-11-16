/**
 * Base class for all data providers which provide additional dynamic information about a specific static data provider instance.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIResourceCombinationProvider extends UIDataProvider
	native(UIPrivate)
	PerObjectConfig
	Config(Game)
	implements(UIListElementProvider)
	abstract;

/**
 * Each combo provider is linked to a single static resource data provider.  The name of the combo provider should match the name of the
 * static resource it's associated with, as the dynamic resource data store will match combo providers to the static provider with the same name.
 */
var	transient	UIResourceDataProvider					StaticDataProvider;

/**
 * The data provider which provides access to a player's profile data.
 */
var	transient	UIDataProvider_OnlineProfileSettings	ProfileProvider;

cpptext
{


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

/**
 * Provides the data provider with the chance to perform initialization, including preloading any content that will be needed by the provider.
 *
 * @param	bIsEditor					TRUE if the editor is running; FALSE if running in the game.
 * @param	InStaticResourceProvider	the data provider that provides the static resource data for this combo provider.
 * @param	InProfileProvider			the data provider that provides profile data for the player associated with the owning data store.
 */
event InitializeProvider( bool bIsEditor, UIResourceDataProvider InStaticResourceProvider, UIDataProvider_OnlineProfileSettings InProfileProvider )
{
	StaticDataProvider = InStaticResourceProvider;
	ProfileProvider = InProfileProvider;
}

`define		debug_resourcecombo_provider	1==0

/**
 * Clears all references in this data provider.  Called when the owning data store is unregistered.
 */
function ClearProviderReferences()
{
	StaticDataProvider = None;
	ProfileProvider = None;
}


DefaultProperties
{

}
