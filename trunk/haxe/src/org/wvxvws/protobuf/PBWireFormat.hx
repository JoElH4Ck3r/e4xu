/**
 * ...
 * @author wvxvw
 */
package org.wvxvws.protobuf;

class PBWireFormat 
{
	public static var WIRETYPE_VARINT:Int = 0;
	public static var WIRETYPE_FIXED64:Int = 1;
	public static var WIRETYPE_LENGTH_DELIMITED:Int = 2;
	public static var WIRETYPE_START_GROUP:Int = 3;
	public static var WIRETYPE_END_GROUP:Int = 4;
	public static var WIRETYPE_FIXED32:Int = 5;

	public static var TAG_TYPE_BITS:Int = 3;
	public static var TAG_TYPE_MASK:Int = 7;

	// Field numbers for fields in MessageSet wire format.
	public static var MESSAGE_SET_ITEM:Int = 1;
	public static var MESSAGE_SET_TYPE_ID:Int = 2;
	public static var MESSAGE_SET_MESSAGE:Int = 3;

	// Tag numbers.
	public static var MESSAGE_SET_ITEM_TAG:Int = 11;
	public static var MESSAGE_SET_ITEM_END_TAG:Int = 12;
	public static var MESSAGE_SET_TYPE_ID_TAG:Int = 16;
	public static var MESSAGE_SET_MESSAGE_TAG:Int = 26;
	
	/**
		Given a tag value, determines the wire type (the lower 3 bits).
	**/
	public inline static function getTagWireType(tag:Int):Int
	{
		return tag & TAG_TYPE_MASK;
	}

	/**
		Given a tag value, determines the field number (the upper 29 bits).
	**/
	public inline static function getTagFieldNumber(tag:Int):Int
	{
		return tag >>> TAG_TYPE_BITS;
	}

	/**
		Makes a tag value given a field number and wire type.
	**/
	public inline static function makeTag(fieldNumber:Int, wireType:Int):Int
	{
		return (fieldNumber << TAG_TYPE_BITS) | wireType;
	}

	public function new() { }
}