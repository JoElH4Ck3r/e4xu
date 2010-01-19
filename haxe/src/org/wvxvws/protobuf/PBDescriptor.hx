/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.protobuf;

class PBDescriptor 
{
	public static var DOUBLE:Int = 1; // double, exactly eight bytes on the wire.
	public static var FLOAT:Int = 2; // float, exactly four bytes on the wire.
	public static var INT64:Int = 3; // int64, varint on the wire.  Negative numbers
									// take 10 bytes.  Use SINT64 if negative
									// values are likely.
	public static var UINT64:Int = 4; // uint64, varint on the wire.
	public static var INT32:Int = 5; // int32, varint on the wire.  Negative numbers
									// take 10 bytes.  Use SINT32 if negative
									// values are likely.
	public static var FIXED64:Int = 6; // uint64, exactly eight bytes on the wire.
	public static var FIXED32:Int = 7; // uint32, exactly four bytes on the wire.
	public static var BOOL:Int = 8; // bool, varint on the wire.
	public static var STRING:Int = 9; // UTF-8 text.
	public static var GROUP:Int = 10; // Tag-delimited message.  Deprecated.
	public static var MESSAGE:Int = 11; // Length-delimited message.

	public static var BYTES:Int = 12; // Arbitrary byte array.
	public static var UINT32:Int = 13; // uint32, varint on the wire
	public static var ENUM:Int = 14; // Enum, varint on the wire
	public static var SFIXED32:Int = 15; // int32, exactly four bytes on the wire
	public static var SFIXED64:Int = 16; // int64, exactly eight bytes on the wire
	public static var SINT32:Int = 17; // int32, ZigZag-encoded varint on the wire
	public static var SINT64:Int = 18; // int64, ZigZag-encoded varint on the wire

	public static var MAX_TYPE:Int = 18; // varant useful for defining lookup tables
										// indexed by Type.
		
	//Descriptor Labels
	public static var LABEL_OPTIONAL:Int = 1; // optional
	public static var LABEL_REQUIRED:Int = 2; // required
	public static var LABEL_REPEATED:Int = 3; // repeated
	public static var MAX_LABEL:Int = 3; // varant useful for defining lookup tables
										// indexed by Label.
	public var fieldName:String;
	public var label:Int;
	public var fieldNumber:Int;
	public var type:Int;
	public var messageClass:String;
	
	public function new(name:String, messageClass:String, 
						type:Int, label:Int, fieldNumber:Int) 
	{
		this.fieldName = name;
		this.messageClass = messageClass;
		this.type = type;
		this.label = label;
		this.fieldNumber = fieldNumber;
	}
	
	public function isOptional():Bool { return this.label === LABEL_OPTIONAL; }
	public function isRequired():Bool { return this.label === LABEL_REQUIRED; }
	public function isRepeated():Bool { return this.label === LABEL_REPEATED; }
	public function isMessage():Bool { return this.type === MESSAGE; }
}