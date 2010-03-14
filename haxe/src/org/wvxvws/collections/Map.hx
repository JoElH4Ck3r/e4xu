/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.collections;

class MapIter<T>
{
    private var _node:Node<T>;

    public function new(node:Node<T>) { this._node = node; }

    public function hasNext():Bool { return this._node != null; }

    public function next():T
	{
		var ret:Node<T> = this._node;
		this._node = this._node.next;
		return ret.value;
	}
}

class MapFilerIter<T>
{
    private var _node:Node<T>;
    private var _doStep:Bool;
	private var _filter:String->T->Bool;

    public function new(node:Node<T>, filter:String->T->Bool)
	{
		this._node = node;
		this._doStep = false;
		this._filter = filter;
	}

    public function hasNext():Bool
	{
		if (this._node == null) return false;
		if (this._doStep)
		{
			this._node = this._node.next;
			this._doStep = false;
		}
		while (true)
		{
			if (this._node == null) return false;
			else if (!this._filter(this._node.name, this._node.value))
			{
				this._node = this._node.next;
			}
			else
			{
				this._doStep = true;
				return true;
			}
		}
		return false;
	}

    public function next():T { return this._node.value; }
}

class MapAllIter<T>
{
    private var _node:Node<T>;
	private var _filter:String->T->Bool;
	private var _doStep:Bool;

    public function new(node:Node<T>, filter:String->T->Bool)
	{
		this._node = node;
		this._filter = filter;
		this._doStep = false;
	}

    public function hasNext():Bool
	{
		var m:Map<T>;
		
		if (this._node == null) return false;
		if (this._doStep)
		{
			if (Std.is(this._node, Map))
			{
				m = cast this._node;
				if (m.head != null) this._node = m.head;
				else if (this._node.next != null) this._node = this._node.next;
				else 
				{
					while (m.next == null) m = m.parent;
					this._node = m.next;
				}
			}
			else if (this._node.next != null) this._node = this._node.next;
			else
			{
				m = this._node.parent;
				if (m == null) return false;
				while (m.next == null)
				{
					m = m.parent;
					if (m == null) return false;
				}
				this._node = m.next;
			}
			this._doStep = false;
		}
		while (true)
		{
			if (this._node == null) return false;
			else if (!this._filter(this._node.name, this._node.value))
			{
				if (Std.is(this._node, Map))
				{
					m = cast this._node;
					if (m.head != null) this._node = m.head;
					else if (this._node.next != null) this._node = this._node.next;
					else 
					{
						while (m.next == null)
						{
							m = m.parent;
							if (m == null) return false;
						}
						this._node = m.next;
					}
				}
				else if (this._node.next != null) this._node = this._node.next;
				else
				{
					m = this._node.parent;
					if (m == null) return false;
					while (m.next == null)
					{
						m = m.parent;
						if (m == null) return false;
					}
					this._node = m.next;
				}
			}
			else
			{
				this._doStep = true;
				return true;
			}
		}
		return false;
	}

    public function next():T { return return this._node.value; }
}

class Map<T> extends Node<T>
{
	public var head:Node<T>;
	
	private var _uniqueKeys:Bool;
	
	public function new(uniqueKeys:Bool, ?value:T, ?parent:Map<T>, ?root:Map<T>)
	{
		super(value, parent, root);
		this._uniqueKeys = uniqueKeys;
	}
	
	public function iterator():MapIter<T>
	{
		return new MapIter<T>(this.head);
	}
	
	public function filter(f:String->T->Bool):MapFilerIter<T>
	{
		return new MapFilerIter<T>(this.head, f);
	}
	
	public function all(f:String->T->Bool):MapAllIter<T>
	{
		return new MapAllIter<T>(this.head, f);
	}
	
	public function add(name:String, value:T):Void
	{
		var n:Node<T>;
		if (this._uniqueKeys)
		{
			n = this.head;
			while (n != null)
			{
				if (n.name == name)
				{
					throw "Keys must be unique";
					return;
				}
				n = n.next;
			}
		}
		n = new Node<T>(value, this, this._root);
		n.name = name;
		if (this.head == null) this.head = n;
		else
		{
			this.head.previous = n;
			n.next = this.head;
			this.head = n;
		}
	}
	
	public function get(name:String, ?values:List<T>):T
	{
		var n:Node<T>;
		if (this._uniqueKeys) return this._get(name).value;
		else
		{
			n = this.head;
			while (n != null)
			{
				if (n.name == name) values.add(n.value);
				n = n.next;
			}
			return null;
		}
	}
	
	private inline function _get(name:String):Node<T>
	{
		var n:Node<T> = this.head;
		while (n != null && n.name != name) n = n.next;
		return n;
	}
	
	public function set(name:String, value:T):Void
	{
		var n:Node<T> = this._get(name);
		n.value = value;
	}
	
	public function map(mapNode:String, childNode:String):Void
	{
		var n:Node<T> = this._get(mapNode);
		var t:Node<T> = this._get(childNode);
		if (t.previous != null) t.previous.next = t.next;
		if (t.next != null) t.next.previous = t.previous;
		t.next = null;
		t.previous = null;
		var m:Map<T>;
		if (Type.typeof(n) != Type.typeof(this))
		{
			m = new Map<T>(this._uniqueKeys);
			m.value = n.value;
			m.name = n.name;
			m.next = n.next;
			m.previous = n.previous;
			m.parent = n.parent;
			if (n.previous != null) n.previous.next = m;
			if (n.next != null) n.next.previous = m;
			if (n.parent.head == n) n.parent.head = m;
		}
		else m = cast n;
		if (m.head == null) m.head = t;
		else if (t != m.head)
		{
			t.next = m.head;
			m.head = t;
		}
		t.parent = m;
	}
	
	public function kick(name:String):Void
	{
		var n:Node<T> = this._get(name);
		if (n.previous != null) n.previous.next = n.next;
		if (n.next != null) n.next.previous = n.previous;
		n.previous = null;
		n.next = null;
	}
	
	#if (debug && flash9)
	public override function toString():String
	{
		var buf:StringBuf = new StringBuf();
		var n:Node<T> = this.head;
		var tab:String = "";
		var p:Node<T> = this.parent;
		var s:String = 
			untyped __global__["flash.utils.getQualifiedClassName"](this.value);
		
		while (p != null && p != this._root)
		{
			tab += "\t";
			p = p.parent;
		}
		buf.add("Map<" + s + ">(");
		buf.add(this.name);
		buf.add(" => ");
		buf.add(this.value);
		buf.addChar(41);
		buf.addChar(13);
		buf.add(tab);
		buf.addChar(123);
		buf.addChar(13);
		while (n != null)
		{
			buf.add(tab);
			buf.addChar(9);
			buf.add(n.toString());
			buf.addChar(13);
			n = n.next;
		}
		buf.add(tab);
		buf.addChar(125);
		return buf.toString();
	}
	#end
}