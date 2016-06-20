# InterfaceBuilder

## Road map/features

Basic possibilities:
- [x] Read interface from some kind of a source (XML)
- [x] Build instances of view classes
- [x] Organize subviews according to source hierarchy
- [x] Read parameters 
- [x] Set parameters to view instances - Primitives (integer, floating point), NSNumber, NSString
- [x] Plugin system
 
Layout:
- [x] Basic frame layout using x, y, width and height parameters
- [ ] Autolayout
- [ ] Relative autolayout
- [ ] Stack layout

Base UIView and UIViewController classes:
- [ ] IBView class that creates itself from a source
- [ ] IBViewController class creates itself from a source
- [ ] Linking a view instance (specified in source) to an IBView/IBViewController subclass property

Live reload:
- [ ] Track source file and recreate IBView/IBViewController when it's changed

Error reporting:
- [ ] Provide user with useful error feedback when something goes wrong 

Styling:
- [ ] ???
