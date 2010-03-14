/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.collections;

class Node<T>
{
	public var previous:Node<T>;
	public var next:Node<T>;
	public var name:String;
	public var value:T;
	public var parent:Map<T>;
	
	private var _root:Map<T>;

	public function new(?value:T, ?parent:Map<T>, ?root:Map<T>) 
	{
		this.value = value;
		this.parent = parent;
		this._root = root;
		if (this.parent != null && this._root == null)
			this._root = this.parent.root();
	}
	
	public function root():Map<T> { return this._root; }
	
	#if (debug && flash9)
	public function toString():String
	{
		var s:String = untyped __global__["flash.utils.getQualifiedClassName"](this.value);
		var buf:StringBuf = new StringBuf();
		buf.add("Node<" + s + ">(");
		buf.add(this.name);
		buf.add(" => ");
		buf.add(this.value);
		buf.addChar(41);
		return buf.toString();
	}
	#end
}