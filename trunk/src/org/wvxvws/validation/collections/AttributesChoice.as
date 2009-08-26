package org.wvxvws.validation.collections 
{
	import org.wvxvws.validation.Attribute;
	import org.wvxvws.validation.Node;
	import org.wvxvws.validation.validation_internal;
	import org.wvxvws.validation.ValidationError;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class AttributesChoice extends Attributes
	{
		
		public function AttributesChoice(attributes:Array = null) { super(attributes); }
		
		public override function validate(attributes:Object, owner:Node):Boolean 
		{
			var att:Attribute;
			var isMatch:Boolean;
			super._error = null;
			for (var obj:Object in this)
			{
				att = obj as Attribute;
				for (var p:String in attributes)
				{
					if (att.validate(p, attributes[p]))
					{
						if (!isMatch) isMatch = true;
						else
						{
							super._error = 
								new ValidationError(ValidationError.MUST_BE_SINGLE);
							super._error.validation_internal::setContext(
											attributesToString(attributes), this);
							return false;
						}
					}
				}
			}
			if (!isMatch)
			{
				super._error = new ValidationError(ValidationError.MISSING_ATTRIBUTE);
				super._error.validation_internal::setContext(
									attributesToString(attributes), this);
				return false;
			}
			return true;
		}
	}
	
}