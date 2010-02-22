package  
{
	/**
	 * ...
	 * @author wvxvw
	 */
	public class CSSReader
	{
		protected var _source:String;
		protected var _position:int;
		protected var _length:int;
		protected var _char:String;
		
		public function CSSReader(source:String) 
		{
			super();
			this._source = source;
			this._position = 0;
			this._length = this._source.length;
		}
		
		protected function readChar():Boolean
		{
			this._char = this._source.charAt(this._position);
			this._position++;
			return this._position < this._length;
		}
		
		protected function readSelector():Boolean
		{
			while (this.readChar())
			{
				if (this._char == "{")
				{
					
					break;
				}
			}
			return this._position < this._length;
		}
		
		protected function readDefinition():Boolean
		{
			
			return this._position < this._length;
		}
		
		protected function readNameValue():Boolean
		{
			
			return this._position < this._length;
		}
		
		protected function readName():Boolean
		{
			
			return this._position < this._length;
		}
		
		protected function readValue():Boolean
		{
			
			return this._position < this._length;
		}
	}
}