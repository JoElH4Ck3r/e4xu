package org.wvxvws.validation.collections 
{
	import org.wvxvws.validation.Attribute;
	import org.wvxvws.validation.Node;
	import org.wvxvws.validation.ValidationError;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class AttributesOptional extends Attributes
	{
		
		public function AttributesOptional(attributes:Array = null) { super(attributes); }
		
		public override function validate(attributes:Object, owner:Node):Boolean 
		{
			var att:Attribute;
			var isMatch:Boolean;
			
			for (var obj:Object in this)
			{
				att = obj as Attribute;
				isMatch = false;
				for (var p:String in attributes)
				{
					if (!att.validate(p, attributes[p]) && 
						att.error.errorID !== ValidationError.BAD_NAME)
					{
						super._error = att.error;
						return false;
					}
				}
			}
			return true;
		}
	}
	
}