/**
 * ...
 * @author wvxvw
 */
package org.wvxvws.protobuf;

enum PBException
{
	/**
		While parsing a protocol message, the input ended unexpectedly 
		in the middle of a field.  This could mean either than the 
		input has been truncated or that an embedded message 
		misreported its own length.
	**/
	TruncatedMessage;
	
	/**
		CodedInputStream encountered an embedded string or message 
		which claimed to have negative size.
	**/
	NegativeSize;
	
	/**
		CodedInputStream encountered a malformed varint.
	**/
	MalformedVarint;
	
	/**
		Protocol message contained an invalid tag (zero).
	**/	
	InvalidTag;
	
	/**
		Protocol message end-group tag did not match expected tag.
	**/
	InvalidEndTag;
	
	/**
		Protocol message tag had invalid wire type.
	**/
	InvalidWireType;
	
	/**
		Protocol message had too many levels of nesting.  May be malicious.  
		Use CodedInputStream.setRecursionLimit() to increase the depth limit.
	**/
	RecursionLimitExceeded;
	
	/**
		Protocol message was too large.  May be malicious.  
		Use CodedInputStream.setSizeLimit() to increase the size limit.
	**/
	SizeLimitExceeded;
}