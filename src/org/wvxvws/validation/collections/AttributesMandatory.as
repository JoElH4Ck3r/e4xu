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
	public class AttributesMandatory extends Attributes
	{
		
		public function AttributesMandatory(attributes:Array = null) { super(attributes); }
		
		public override function validate(attributes:Object, owner:Node):Boolean 
		{
			var att:Attribute;
			var isMatch:Boolean;
			
			for (var obj:Object in this)
			{
				att = obj as Attribute;
				att.startValidate();
				isMatch = false;
				for (var p:String in attributes)
				{
					if (att.validate(p, attributes[p]))
					{
						isMatch = true;
						break;
					}
				}
				if (!isMatch)
				{
					super._error = new ValidationError(ValidationError.MISSING_ATTRIBUTE, owner, att);
					super._error.validation_internal::setContext(
							super.attributesToString(attributes), this);
					return false;
				}
			}
			return true;
		}
	}
	
}