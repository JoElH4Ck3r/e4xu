*** Syntax guidelines ***

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