﻿package org.wvxvws.signals 
{
	import flash.utils.Dictionary;
	//{ imports
		
	//}
	
	/**
	 * Signal class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class Signals 
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
		
		protected var _allStrong:Dictionary = new Dictionary();
		protected var _allWeak:Dictionary = new Dictionary(true);
		protected var _semaphore:ISemaphore;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Signals(scope:ISemaphore) 
		{
			super();
			this._semaphore = scope;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function add(type:SygnalType, slot:Function, priority:int = -1, 
			params:Vector.<Class> = null, weak:Boolean = false):void
		{
			var sig:Vector.<Class>;
			var target:Dictionary;
			var alter:Dictionary;
			if (!this._semaphore.signalTypes().indexOf(type))
				throw SignalError.NO_TYPE;
			sig = this._semaphore.callbackSignature(type);
			for (var i:int; ; i++)
			{
				if (sig === params) break;
				if (!sig || !params || 
					sig.length !== params.length)
				{
					throw SignalError.WRONG_SIGNATURE;
					break;
				}
				if (i < sig.length && sig[i] === params[i])
					continue;
				else if (i === sig.length) break;
				else
				{
					throw SignalError.WRONG_SIGNATURE;
					break;
				}
			}
			if (weak)
			{
				if (!this._allWeak[type]) this._allWeak[type] = new Dictionary(true);
				target = this._allWeak[type] as Dictionary;
				alter = this._allStrong[type] as Dictionary;
			}
			else
			{
				if (!this._allStrong[type]) this._allStrong[type] = new Dictionary();
				target = this._allStrong[type] as Dictionary;
				alter = this._allWeak[type] as Dictionary;
			}
			if (alter) delete alter[slot];
			target[slot] = priority;
		}
		
		public function rem(type:SygnalType, slot:Function):Function
		{
			
		}
		
		public function call(type:SygnalType, ...params):void
		{
			var temp:Dictionary = new Dictionary();
			var o:Object;
			var strong:Dictionary = this._allStrong[type];
			var weak:Dictionary = this._allWeak[type];
			// Vector requires callback for sorting
			var indices:Array/*int*/ = [];
			if (strong === weak)
			{
				throw SignalError.NO_TYPE;
				return;
			}
			for (o in strong) indices.push(temp[o] = strong[o]);
			for (o in weak) indices.push(temp[o] = weak[o]);
			indices.sort();
			var len:int = indices.length;
			for (var i:int; i < len; i++)
			{
				for (o in temp)
				{
					if (temp[o] === indices[i])
					{
						(o as Function).apply(null, params.concat());
						break;
					}
				}
				delete temp[o];
			}
		}
		
		public function all(weak:Boolean = false):Dictionary
		{
			
		}
		
		public function has(slot:Function):Boolean
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
}