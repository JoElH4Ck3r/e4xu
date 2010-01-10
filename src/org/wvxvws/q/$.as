package org.wvxvws.q 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * $ Function.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public function $(target:IEventDispatcher):_
	{
		return new _(target);
	}
}
import flash.events.IEventDispatcher;

internal final class _
{
	private var _reg:*;
	private var _target:IEventDispatcher;
	
	public function _(target:IEventDispatcher)
	{
		super();
		this._target = target;
	}
	
	public function call(f:Function):_
	{
		
		return this;
	}
	
	public function args(...rest):_
	{
		
		return this;
	}
	
	public function i(name:Object):_
	{
		
		return this;
	}
	
	public function val(value:Object):_
	{
		
		return this;
	}
	
	public function z():void
	{
		
	}
	
	public function on(event:String):_
	{
		//(this._target as IEventDispatcher).addEventListener(event, create(this._target, ));
		return this;
	}
	
}

internal function create(scope:Object, f:Function, args:Array = null):Function
{
	var fn:Function = function():*
	{
		if (args) return f.apply(scope, args);
		return f.call(scope);
	}
	return fn;
}
