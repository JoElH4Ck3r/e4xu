package org.wvxvws.binding 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	
	/**
	 * BindingContext class.
	 * @author wvxvw
	 */
	public class BindingContext
	{
		public static const BINDABLE:String = "Bindable";
		
		protected var _sight:IEventDispatcher;
		protected var _bindingInfo:Object = { };
		protected var _eventsTable:Object = { };
		
		public function BindingContext(sight:IEventDispatcher)
		{
			super();
			_sight = sight;
			var list:XMLList = describeType(_sight)..accessor.(
				valueOf().metadata.@name == BINDABLE);
			for each (var p:XML in list)
			{
				_bindingInfo[p.localName().toString()] = 
					p.metadata.(@name == BINDABLE)[0].arg.@value.toString();
			}
		}
		
		public function add(fromProperty:String, to:Object, toProperty:String):void
		{
			var eventName:String;
			var links:Array;
			var ib:IBindable;
			var i:int;
			if (toProperty.indexOf(".") > -1 || toProperty.indexOf("[") > -1)
			{
				links = toProperty.split(/[\.\[\]]/g);
				ib = _sight[links[0]] as IBindable;
				while (ib && i < links.length)
				{
					ib = ib[links[i]] as IBindable;
					i++;
				}
				if (!ib) ib = links[i - 1] as IBindable;
			}
			else
			{
				eventName = _bindingInfo[fromProperty];
			}
			_sight.addEventListener(eventName, this.bindingHandler);
			if (!_eventsTable[eventName]) _eventsTable[eventName] = new <Pair>[];
			var pairs:Vector.<Pair> = _eventsTable[eventName];
			pairs.push(new Pair(to, toProperty));
		}
		
		protected function bindingHandler(event:Event):void
		{
			var pairs:Vector.<Pair> = _eventsTable[event.type];
			var propName:String;
			var newVal:*;
			for (var p:String in _bindingInfo)
			{
				if (_bindingInfo[p] === event.type)
				{
					propName = p;
					break;
				}
			}
			newVal = _sight[propName];
			for each (pr:Pair in pairs)
			{
				pr.to[pr.toProperty] = newVal;
			}
		}
	}
}
internal final class Pair
{
	public var to:Object;
	public var toProperty:String;
	
	public function Pair(to:Object, toProperty:String)
	{
		super();
		this.to = to;
		this.toProperty = toProperty;
	}
}