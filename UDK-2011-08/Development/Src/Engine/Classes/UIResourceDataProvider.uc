/**
 * Base class for data providers which provide data for static game resources.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIResourceDataProvider extends UIPropertyDataProvider
	native(inherit)
	implements(UIListElementProvider)	//@todo - what about script-only subclasses?
	Config(Game)
	PerObjectConfig
	abstract;

/**
 * Controls which properties this data provider will expose as data fields.  Specify TRUE to only allow properties marked
 * with the 'databinding' keyword to be exposed.
 *
 * Child classes may override or ignore this flag by using different logic in GetSupportedDataFields().
 */
var		bool	bDataBindingPropertiesOnly;

/** Controls whether the object should be used or not. This is the only way to remove a per object config from the list */
var config bool bSkipDuringEnumeration;

cpptext
{
public:
	/* === UUIResourceDataProvider interface === */
	/**
	 * Determine if the specified tag corresponds to a collection or provider collection
	 *
	 * @param	FieldTag				the name of the field to check
	 * @param	out_CollectionProperty	if valid, receives a reference to the property which corresponds to the tag specified.
	 *
	 * @return	TRUE if the specified tag is a static or dynamic array property.
	 */
	virtual UBOOL IsCollectionProperty( FName FieldTag, UProperty** out_CollectionProperty=NULL );

	/**
	 * Gets the list of properties in this class which correspond to arrays.
	 *
	 * @param	out_CollectionProperties	receives the list of array properties
	 *
	 * @return	TRUE if array properties were found.
	 */
	virtual UBOOL GetCollectionProperties( TArray<UProperty*>& out_CollectionProperties );

	/**
	 * Attempts to find a nested data provider given the parameters
	 *
	 * @param	CollectionProperty	the property that potentially holds the reference to the data provider
	 * @param	CollectionIndex		the index into the collection for the data provider to retrieve; if the value is invalid, the default
	 *								object for the property class will be used.
	 * @param	InternalProvider	receives the reference to the provider, if found.
	 *
	 * @return	TRUE if the property held a reference to a data provider (even if a NULL provider was found).
	 */
	virtual UBOOL GetNestedProvider( UProperty* CollectionProperty, INT CollectionIndex, UUIDataProvider*& InternalProvider );

	/* === UUIPropertyDataProvider interface === */
	/**
	 * Returns whether the specified property type is renderable in the UI.
	 *
	 * @param	Property				the property to check
	 * @param	bRequireNativeSupport	TRUE to require the property to be natively supported (i.e. don't check whether it's supported in script).
	 *
	 * @return	TRUE if this property type is something that can be rendered in the UI.
	 *
	 * @note: can't be const it must call into the script VM, where we can't guarantee that the object's state won't be changed.
	 */
	virtual UBOOL IsValidProperty( UProperty* Property, UBOOL bRequireNativeSupport=FALSE );


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
 * @param	bIsEditor	TRUE if the editor is running; FALSE if running in the game.
 */
event InitializeProvider( bool bIsEditor );

DefaultProperties
{
	//@fixme ronp - it might be better to handle this via the script custom handlers
	ComplexPropertyTypes.Remove(class'ArrayProperty')
}
