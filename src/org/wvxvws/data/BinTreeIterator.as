package org.wvxvws.data 
{
	//{ imports
		
	//}
	
	/**
	 * BinTreeIterator class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class BinTreeIterator implements IIterator
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.data.IIterator */
		
		public function get next():Function
		{
			
		}
		
		public function get current():Function
		{
			
		}
		
		public function get position():int
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _rule:Function;
		protected var _tree:DataBinTree;
		
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
		
		public function BinTreeIterator(tree:DataBinTree) 
		{
			super();
			this._tree = tree;
			this._rule = tree.rule;
		}
		
		/* INTERFACE org.wvxvws.data.IIterator */
		
		public function hasNext():Boolean
		{
			
		}
		
		public function reset():void
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
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