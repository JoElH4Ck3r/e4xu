package org.wvxvws.xmlutils
{
	import flash.utils.getQualifiedClassName;
	
	/**
	* XMLUtils class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class XMLUtils 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static const ATTRIBUTE_VALUE:String = "%attribute value%";
		private static const GENERATOR:String = "ABCDEFGHIJKLMNOP";
		
		private static var _hash:Object = { };
		private static var _collection:Array = [];
		private static var _uidindex:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * All of the methods of this class are static, there's no need 
		 * to instantiate it.
		 */
		public function XMLUtils() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Searches for the first attribute from the specified position.
		 * 
		 * @param	list		XMLList. The list of nodes to perform a search.
		 * @param	attr		String. The attribute name to search for.
		 * @param	val			String. The attribute value to search for.
		 * @param	position	int. The position to start searching from.
		 * @default	0. If not specified will search from the first node onwards.
		 * 
		 * @return	int. -1 if the searched match wasn't found, or zero based index 
		 * 			of the searched node.
		 */
		public static function indexOfAttribute(list:XMLList, attr:String, val:String,
																position:int = 0):int
		{
			var i:int;
			var found:int = -1;
			list.(attribute(attr) == val && i > position && found == -1 ? found = i : i++);
			return found;
		}
		
		/**
		 * Searches for the last attribute before the specified position.
		 * 
		 * @param	list		XMLList. The list of nodes to perform a search.
		 * @param	attr		String. The attribute name to search for.
		 * @param	val			String. The attribute value to search for.
		 * @param	position	int. The last position to be considered.
		 * @default	0x7FFFFFFF (<code>int.MAX_VALUE</code>).
		 * 
		 * @return	int. -1 if the searched match wasn't found, or zero based index 
		 * 			of the searched node.
		 */
		public static function lastIndexOfAttribute(list:XMLList, attr:String, 
											val:String, position:int = 0x7FFFFFFF):int
		{
			var i:int;
			var found:int = -1;
			list.(attribute(attr) == val && i < position ? found = i++ : i++);
			return found;
		}
		
		/**
		 * Slices the XMLList into array.
		 * 
		 * @param	list			XMLList. The list to be sliced.
		 * @param	keepReferences	Boolean. If set to true, will use 
		 * 			the nodes from the list. Otherwise will populate 
		 * 			the array with copied nodes.
		 * @default	<code>true</code>	If set to <code>true</code>, 
		 * 			will use nodes from the list, otherwise
		 * 			will populate array with copied nodes.
		 * 
		 * @return	Array. The array containing XMLs for each node in the list.
		 */
		public static function listToArray(list:XMLList, keepReferences:Boolean = true):Array
		{
			var arr:Array = [];
			if (keepReferences) list.(arr.push(valueOf()));
			else list.(arr.push(copy()));
			return arr;
		}
		
		/**
		 * Creates an XMLList from XML onjects contained within an array.
		 * 
		 * @param	array			Array. The array of XML objects.
		 * @param	keepReferences	Boolean. If set to <code>true</code> will use the XML
		 * 			objects from the array, otherwise will copy the XMLs.
		 * @default	<code>true</code>	If set to <code>true</code> will use the XML
		 * 			objects from the array, otherwise will copy the XMLs.
		 * 
		 * @return	XMLList. The collection of nodes contained within the passed array.
		 * 
		 * @see		<a href="#multyArrayToList()">multyArrayToList()</a>
		 */
		public static function arrayToList(array:Array, keepReferences:Boolean = true):XMLList
		{
			var cloneArray:Array = array.slice();
			var list:XMLList = keepReferences ? XMLList(cloneArray.shift()) :
								XMLList(cloneArray.shift().copy());
			if (keepReferences)
			{
				while (cloneArray.length) list += XML(cloneArray.shift());
			}
			else
			{
				while (cloneArray.length) list += XML(cloneArray.shift().copy());
			}
			return list;
		}
		
		/**
		 * Unlike the <a href="#arrayToList()">arrayToList()</a> function, 
		 * will parse objects contained within an array to XML objects 
		 * and generates a new XMLList.
		 * 
		 * @param	array	Array. The array of objects to be parsed into XMLs.
		 * 
		 * @return	XMLList. The XMLList representing the given array.
		 * 
		 * @see		<a href="#arrayToList()">arrayToList()</a>
		 */
		public static function multyArrayToList(array:Array):XMLList
		{
			var cloneArray:Array = array.slice();
			var list:XMLList = XMLList(objectToXML(cloneArray.unshift()));
			while (cloneArray.length) list += objectToXML(cloneArray.unshift());
			return list;
		}
		
		/**
		 * Creates a new XML object from the object and it's properties 
		 * provided in the arguments.
		 * 
		 * @param	object		Object. The object to be parsed into XML.
		 * @param	nodeName	String. If you don't specify a new name 
		 * 			for the root XML node
		 * 			od the resulting XML it'll became &lt;node/&gt;.
		 * 
		 * @return	XML. New XML object generated from the object provided in arguments.
		 */
		public static function objectToXML(object:Object, nodeName:String = "node"):XML
		{
			if (object is XML) return XML(object);
			if (isXMLName(object)) object = QName(object).localName;
			var xml:XML = <{nodeName}/>;
			var check:XML;
			for (var p:String in object)
			{
				trace(p, object[p]);
				check = objectToXML(object[p], p);
				if (check.hasSimpleContent() && !check.@*.length()) xml.@[p] = object[p];
				else xml.appendChild(check);
			}
			return xml;
		}
		
		/**
		 * Removes all namespce declarations as well as namespaces themeselves from the
		 * XML provided in the arguments and all it's descendants.
		 * 
		 * @param	xml	XML. The XML to be stripped of namespaces.
		 * 
		 * @return	XML. New XML object with data structure of the XML provided in
		 * 			arguments, however, without namespaces.
		 */
		public static function stripNameSpaces(xml:XML):XML
		{
			var xmlSource:String = xml.toXMLString();
			xmlSource = xmlSource.replace(/<[^!?]?[^>]+?>/g, removeNamspaces);
			return XML(xmlSource);
		}
		
		/**
		 * Sorts the XMLList much like the <code>Array.sort()</code> does.
		 * 
		 * @param	list	XMLList. The XMLList to be sorted.
		 * @param	options	Object. May be of the following types:<br/>
		 * 			String. If you provide a string, the behavior will be the same as 
		 * 			of <code>Array.sortOn("parameter")</code><br/>
		 * 			int. If you provide an integer, then the behavior will be the same
		 * 			as of <code>Array.sortOn(0-31)</code>. You may use Array constants 
		 * 			for this sorting operation, the same rules apply.<br/>
		 * 			Function. If you specify the function as an option, this function will 
		 * 			be called with the following arguments: previous XML node and next XML node.
		 * 			The function signature should look like this:<br/>
		 * 			<code>function sortingFunction(a:XML, b:XML):int</code>.
		 * 
		 * @return	XMLList. The sorted XMLList.
		 * 
		 * @throws ArgumentError. "options" argument cannot be of type <i>type</i>!
		 */
		public static function sort(list:XMLList, options:Object = null):XMLList
		{
			var arr:Array = listToArray(list);
			switch (true)
			{
				case (options == null):
					arr.sort();
					break;
				case (options is String):
				case (options is int):
					arr.sortOn(options);
					break;
				case (options is Function):
					arr.sort(options);
					break;
				default:
					throw new ArgumentError("\"options\" argument cannot be of type " +
					getQualifiedClassName(options) + "!");
					break;
			}
			return arrayToList(arr);
		}
		
		/**
		 * Searches the XML for identical child nodes and removes them.
		 * This function doesn't modify the original XML.
		 * 
		 * @param	xml	XML. XML to be searched for identical nodes.
		 * 
		 * @return	XML. The XML containing no identical nodes.
		 */
		public static function removeDuplicates(xml:XML):XML
		{
			var result:XML = <{xml.name()}/>;
			_collection = [];
			var list:XMLList = xml.*.(checkDuplicate(copy()));
			_collection = [];
			result.setChildren(list);
			return result;
		}
		
		/**
		 * Creates a one-level copy of the provided XML. I.e. this copy will contain
		 * the attributes of the copied XML, no child nodes will be copied.
		 * 
		 * @param	xml	XML. The XML to copy.
		 * 
		 * @return	XML. New copied XML.
		 */
		public static function shallowCopy(xml:XML):XML
		{
			var result:XML = <{xml.name()}/>;
			xml.@*.(result.@[name()] = toXMLString());
			return result;
		}
		
		/**
		 * Creates a list of N nodes with the optional randomization.<br/>
		 * Note that if you supply quantity greater then the number of nodes, 
		 * the list will contain as many nodes as there are in the XML. If randomize
		 * is set to <code>false</code> the returned nodes are the first children
		 * of the provided XML.
		 * 
		 * @param	xml			XML. The XML to extract nodes from.
		 * @param	quantity	uint. How many nodes to extract.
		 * @param	randomise	Boolean. Whether or not to randomize the list.
		 * @default	<code>false</code>	The nodes are not randomized by default.
		 * 
		 * @return	XMLList. The list containing some nodes.
		 */
		public static function few(xml:XML, quantity:uint, 
											randomise:Boolean = false):XMLList
		{
			var nodes:XMLList = xml.*;
			if (nodes.length() < quantity) quantity = nodes.length();
			var list:XMLList;
			var hash:Array = [];
			var node:XML;
			var i:uint;
			do
			{
				node = randomise ? nodes[(Math.random() * nodes.length()) >> 0] :
						nodes[i++];
				if (randomise && hash.indexOf(node.toXMLString()) < 0)
				{
					hash.push(node.toXMLString());
					list ? list += node : list = XMLList(node);
				}
				else if(!randomise) list ? list += node : list = XMLList(node);
			}
			while (list.length() < quantity)
			return list;
		}
		
		/**
		 * Renames all XML nodes such as to shorten the names.
		 * 
		 * @param	xml	XML. The XML to rename. Note, the XML will be renamed in place.
		 * 
		 * @return	Object. The object containing tokens for the generated node names.
		 * 
		 * @see		<a href="#reverseBatchRename()">reverseBatchRename()</a>
		 */
		public static function batchRename(xml:XML):Object
		{
			_hash = { };
			var newHash:Object = { };
			if (_hash[xml.name()]) xml.setName(_hash[xml.name()]);
			else xml.setName(generateUID(xml.name()));
			xml.*.(batchRename(valueOf()));
			for (var p:String in _hash) newHash[p] = _hash[p];
			_hash = { };
			return newHash;
		}
		
		/**
		 * Restores node names previously renamed by 
		 * <a href="#batchRename()">batchRename()</a>. Note, The XML will be chenged in place.
		 * 
		 * @param	xml		XML. The XML to be renamed.
		 * @param	hash	Object. The object containing propery-value pairs to serve as
		 * 					tokens for renaming.
		 * 
		 * @return	XML		The modified XML.
		 */
		public static function reverseBatchRename(xml:XML, hash:Object):XML
		{
			_hash = hash;
			var oldName:String = xml.name();
			for(var p:String in _hash)
			{
				if (_hash[p] == oldName)
				{
					xml.setName(p);
					break;
				}
			}
			xml.*.(reverseBatchRename(valueOf(), _hash));
			return xml;
		}
		
		/**
		 * Inserts one or more XML objects into given XMLList. XMLList is 
		 * modified in place. Acts similar to <code>Array.splice()</code>
		 * 
		 * @param	list	XMLList. The list to insert items
		 * @param	index	int. The position to insert at.
		 * @param	...xmls	One or more objects to be inserted in the list.
		 * 
		 * @return	XMLList. The modified XMLList.
		 */
		public static function insert(list:XMLList, index:int, ...xmls):XMLList
		{
			if (index > list.length() - 1) index = list.length() - 1;
			if (index < 0) index = 0;
			var toInsert:XMLList = XMLList(xmls.shift());
			while (xmls.length) toInsert += xmls.shift();
			toInsert += list[index].copy();
			list[index] = toInsert;
			return list;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * @param	...rest
		 * 
		 * @return	String.
		 */
		private static function removeNamspaces(...rest):String
		{
			rest[0] = rest[0].replace(/xmlns[^"]+\"[^"]+\"/g, "");
			var attrs:Array = rest[0].match(/\"[^"]*\"/g);
			rest[0] = rest[0].replace(/\"[^"]*\"/g, ATTRIBUTE_VALUE);
			rest[0] = rest[0].replace(/(<\/?|\s)\w+\:/g, "$1");
			while (rest[0].indexOf(ATTRIBUTE_VALUE) > 0)
			{
				rest[0] = rest[0].replace(ATTRIBUTE_VALUE, attrs.shift());
			}
			return rest[0];
		}
		
		/**
		 * @private
		 * @param	node	XML.
		 * 
		 * @return	Boolean.
		 */
		private static function checkDuplicate(node:XML):Boolean
		{
			if (_collection.indexOf(node.toXMLString()) > -1) return false;
			_collection.push(node.toXMLString());
			return true;
		}
		
		/**
		 * @private
		 * @param	nodeName	String.
		 * 
		 * @return	String.
		 */
		private static function generateUID(nodeName:String):String
		{
			_uidindex++;
			var pin:String = "";
			var upos:uint = _uidindex;
			var i:int;
			var pos:int;
			while (upos)
			{
				pos = upos % 16;
				upos /= 16;
				i++;
				pin += GENERATOR.charAt(pos);
			}
			_hash[nodeName] = pin;
			return pin;
		}
	}
	
}