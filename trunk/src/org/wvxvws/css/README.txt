*** Syntax guidelines ***

KEYWORDS:

@import <prefix> <uri> 
	- Makes a class from the namespace identified by uri available for use 
	in selectors and style definitions.
Example:
	@import g flash.geom
	@import mc flash.display
	mc|MovieClip { transform.matrix: g|Matrix(1, 1 0, 0, 10, 20) }
Note:
	It is possible to use fully qualified name in the style body, however you must 
	use namespaces in selectors.
	This does not include specified packages in the SWF 
	(subject to change in future versions).

@if TBD.
@elif TBD.
@else TBD.
@end TBD.

@define <name> <value> 
	- Defines a varible with the <name> name and the <value>, where name can use 
	letters and digits and the value syntax is identical to the style property value.
	You can later use defined variable by prefixing them with ?.
Example:
	@import mc flash.display
	@define foo 12345
	@define bar ~mc|MovieClip()
	@define foobar ~abc|SomeClass/someStaticProperty.someMethod("foo", true)
	Foo { prop1: ?foo; prop2: ?bar; prop3: ?foobar }

@resource <name> <type> [class] { [embed option 1], [embed option 2], ...[embed option N] }
	- Instructs to embed a resource where <name> is the alias similar to @define.
	[class] is optional, if specified will link the resource to a custom class provided.
	<type> may be one of the following:
		* bin - binary data (symbol class must inherit from flash.utils::ByteArray)
		* img - image data (symbol class must inherit from flash.display::Bitmap)
		* snd - sound data (symbol class must inherit from flash.media::Sound)
		* fnt - font data (symbol class must inherit from flash.text::Font)
		* flv - video data (symbol class must inherit from flash.display::MovieClip)

COMMENTS:
// - is the line comment. There aren't block comments.

PROPERTY VALUES:

[~] [^|&] [ns|ClassName] [field name] [( argument0, argument1, ...argumentN )]
	~ - create new instance.
	
	^ - initialize all property with the new instance.
	& - initialize all properties with the same instance.
	
	[ns|ClassName]:
		ns - namespace prefix.
		ClassName - the short class name (not including package).
	[field name]:
		[.|/] [name]
		. - instance field.
		/ - static field.

Note:
	! - used to point to the scope of the element where the style is applied. 
	(same as "this" keyword).
	? - is the reference to the constant defined in this document.

Example:
	mc|MovieClip { filters: ~^*|Array(~&f|BlutFilter(), ~&f|DropShadowFilter()) }
	Will create a new Array and pass the instances of BlutFilter and DropShadowFilter
	by reference.
	
	mc|MovieClip { filters: my|FilterUtils/createFilters("BlutFilter", 
	"DropShadowFilter") }
	Will call static method of FilterUtils custom class by the name "createFilters"
	with arguments "BlutFilter" and "DropShadowFilter".
	
	mc|MovieClip { filters: my|StaticClass/staticProperty.instanceMethod("BlutFilter", 
	"DropShadowFilter") }
	Will call an "instanceMethod" of "staticProperty" of "StaticClass" in a package
	aliased with prefix "my".