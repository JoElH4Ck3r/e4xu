# Introduction #

This project is intended for advanced non-framework MXML coders. If you like the concepts of MXML language, but dislike mx or fx frameworks, hopefully, this one may be interesting to you.


# Details #

The project now is in it's very early stage, though, I'll try to describe it's main concepts.

  * This is a set of independent modules, which may be used together and separately. I try to have as few dependencies as possible. Thus, every third level package should not depend on it's neighbor packages.
Eg.: `org.wvxvws.net.AMFService` cannot depend on `org.wvxvws.gui.Control`, but it may depend on `org.wvxvws.net.Synchronizer`.
  * Project classes, if override methods of their respective Flash classes, should either expose alternative API for performing the same operations or conform to the super-class API. This means there should not be a situation when the methods that override Flash class' method will not accept an argument of the same type as the super-class method or will not clearly restrict it.
Eg.: You cannot add new `Sprite` to any of `mx.core.UIComponent` sub-classes. Consider `org.wvxvws.gui.Control` to be equivalent to `mx.core.UIComponent`. Then the rule states that any sub-class of `org.wvxvws.gui.Control` should either add `Sprite` as a child, or, if it is not possible, should "seal" the super-class method by throwing the error.
  * The features of MXMLC compiler such as bindings, styling and other, which are likely to create over-functionality should be avoided whenever possible.
This means that MXML components should not override super-class methods or properties only to add that functionality. If you need it - extend the base class and create bindings where you need. However, if the component must override method or property for other reasons it should make it bindable, or stylable, or whichever is applicable in the specific situation.
  * Avoiding singletons and global access. Whenever singleton is unavoidable, (see for example `org.wvxvws.mapping.Map`) Such classes must expose clear APIs for their reuse. There should not be global setters.
  * Naming and code styling rules. I will try to keep to the coding conventions for mx framework, although, whenever possible I will try to keep class names short and will try to avoid overlapping names. So, this classes won't create name collisions with framework classes once you would like to use them both.