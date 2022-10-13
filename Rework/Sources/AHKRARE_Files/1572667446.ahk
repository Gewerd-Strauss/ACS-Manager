TV_Load(src, p:=0, recurse:=false) {											     								;-- loads TreeView items from an XML string

/*	Description

a function by Coco found at https://autohotkey.com/boards/viewtopic.php?t=91

This function loads TreeView items from an XML string. By using XPath expressions, the user can instruct the function on how to process/parse
the XML source and on how the items are to be added.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

A. The XML structure

This function is versatile enough to accept any user-defined XML string. Parsing instructions are defined as XPath expressions assigned as values
to the root element's attribute(s). The following attribute names should be used(strictly applies to the root element only):

name - 		specify an XPath expression, query must resolve to either of the following nodeTypes: element, attribute, text, cdatasection, comment.
			The selection is applied to the element node that is defined as a TreeView item. If not defined, the element node's tagName property
			is used as the TreeView's item's name.

options - 	same as above

global - 	An XPath expression. This attribute defines global TreeView item options to be applied to all TreeView items that are to be added.
			Selection is applied to the root node.

exclude - An XPath expression. Specifies which nodes(element) are not to be added as TreeView items. Selection is applied to the root node.

match - An XPath expression. Specifies which element nodes are to be added as TreeView items. By default all element nodes(except the root
		node) are added as items to the TreeView. Selection is applied to the root node.

Note: Only element nodes are added as TreeView items.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

B. Function parameters

src - an XML string
p - parentItem's ID. Defaults to '0' - top item of the TreeView

*/
;recurse is an internal parameter
static xpr , root
static TVL_NAME , TVL_OPTIONS , TVL_GLOBAL , TVL_EXCLUDE , TVL_MATCH

if !xpr
xpr := {TVL_NAME:"@*[translate(name(), 'NAME', 'name')='name']"
	,   TVL_OPTIONS:"@*[translate(name(), 'OPTIONS', 'options')='options']"
	,   TVL_GLOBAL:"@*[translate(name(), 'GLOBAL', 'global')='global']"
	,   TVL_EXCLUDE:"@*[translate(name(), 'EXCLUDE', 'exclude')='exclude']"
	,   TVL_MATCH:"@*[translate(name(), 'MATCH', 'match')='match']"}

if !IsObject(src)
x := ComObjCreate("MSXML2.DOMDocument.6.0")
, x.setProperty("SelectionLanguage", "XPath") ;redundant
, x.async := false , x.loadXML(src)
, src := x.documentElement

if !recurse {
root := src.selectSingleNode("/*") ;src.ownerDocument.documentElement

for var, xp in xpr
	if (var ~= "^TVL_(NAME|OPTIONS|GLOBAL)$")
		%var% := (_:=root.selectSingleNode(xp))
			  ? _.value
			  : (var="TVL_NAME" ? "." : "")

	else if (var ~= "^TVL_(EXCLUDE|MATCH)$")
		%var% := (_:=root.selectSingleNode(xp))
			  ? (_.value<>"" ? root.selectNodes(_.value) : "")
			  : ""
}

for e in src.childNodes {
if (e.nodeTypeString <> "element")
	continue
if (TVL_EXCLUDE && TVL_EXCLUDE.matches(e))
	continue
if (TVL_MATCH && !TVL_MATCH.matches(e))
	continue

for k, v in {name:TVL_NAME, options:TVL_OPTIONS}
	%k% := (n:=e.selectSingleNode(v))[(n.nodeType>1 ? "nodeValue" : "nodeName")]

if (TVL_GLOBAL <> "") {
	go := TVL_GLOBAL
	Loop, Parse, options, % " `t", % " `t"
	{
		if ((alf:=A_LoopField) == "")
			continue
		if InStr(go, m:=RegExReplace(alf, "i)[^a-z]+", ""))
			go := RegExReplace(go, "i)\S*" m "\S*", alf)
		else (go .=  " " . alf)
	}

} else go := options

id := TV_Add(name, p, go)
if e.hasChildNodes()
	TV_Load(e, id, true)
}
;Empty/reset static vars
if !recurse
root := ""
, TVL_NAME := ""
, TVL_OPTIONS := ""
, TVL_GLOBAL := ""
, TVL_EXCLUDE := ""
, TVL_MATCH := ""
}