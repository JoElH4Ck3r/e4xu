package org.wvxvws.automation.language
{
	import flash.utils.Dictionary;
	
	import org.wvxvws.automation.ParensParser;
	import org.wvxvws.automation.nodes.EvalNode;
	import org.wvxvws.automation.nodes.NamedSymbol;
	import org.wvxvws.automation.nodes.Node;

	public class Scope extends EvalNode
	{
		private var _parser:ParensParser;
		
		private var _reverseLookup:Object = { };
		
		private var _currentPackage:ParensPackage;
		
		private var _language:LanguageFunctions;
		
		private var _previousPackage:ParensPackage;
		
		private var _bindings:Dictionary = new Dictionary();
		
		public function Scope(parser:ParensParser)
		{
			super();
			this._parser = parser;
			this._language = parser.language;
		}
		
		public function bindTo(name:NamedSymbol, node:Node):Node
		{
			return this._bindings[name] = node;
		}
		
		public function resolve(name:String):NamedSymbol
		{
			return this._reverseLookup[name];
		}
		
		public function cleanup():void
		{
			if (this._currentPackage)
			{
				this._language.inpackage(this._previousPackage.name);
				this._language.removePackage(this._currentPackage.name);
			}
			for (var node:Object in this._bindings)
				delete this._bindings[node];
		}
		
		public override function eval():*
		{
			var tempContext:String = "" + Math.random();
			var valueNode:Node;
			
			this._previousPackage = this._language.currentPackage();
			this._language.defpackage(tempContext);
			this._currentPackage = this._language.getpackage(tempContext);
			this._language.inpackage(this._currentPackage.name);
			
			for each (var node:NamedSymbol in super._parameters)
			{
				valueNode = this._bindings[node];
				if (valueNode)
					this._language.defvar(node.value, valueNode.value);
				else this._language.defvar(node.value);
			}
		}
		
		public override function add(child:Node):Node
		{
			var symbol:NamedSymbol = NamedSymbol(child);
			this._reverseLookup[symbol.value] = symbol;
			return super.add(child);
		}
	}
}