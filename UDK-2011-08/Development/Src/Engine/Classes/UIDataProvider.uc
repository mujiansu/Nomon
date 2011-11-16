/**
 * Base class for all classes which provide data stores with data about specific instances of a particular data type.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIDataProvider extends UIRoot
	native(UIPrivate)
	transient
	abstract;


/**
 * Contains data about a single data field exposed by this data provider.
 */
struct native transient UIDataProviderField
{
	/** the tag used to access this field */
	var		name									FieldTag;

	/** the type of field this tag corresponds to */
	var		EUIDataProviderFieldType				FieldType;

	/**
	 * The list of providers associated with this field.  Only relevant if FieldType is DATATYPE_Provider or
	 * DATATYPE_ProviderCollection.  If FieldType is DATATYPE_Provider, the list should contain only one element.
	 */
	var	public{private}	array<UIDataProvider>		FieldProviders;

structcpptext
{
	/** Constructors */
	FUIDataProviderField() {}

	FUIDataProviderField( FName InFieldTag, EUIDataProviderFieldType InFieldType=DATATYPE_Property, class UUIDataProvider* InFieldProvider=NULL );
	FUIDataProviderField( FName InFieldTag, const TArray<class UUIDataProvider*>& InFieldProviders );

	/**
	 * Retrieves the list of providers contained by this data provider field.
	 *
	 * @return	FALSE if the FieldType for this provider field is not DATATYPE_Provider/ProviderCollection
	 */
	UBOOL GetProviders( TArray<class UUIDataProvider*>& out_Providers ) const;
}
};

DefaultProperties
{
}