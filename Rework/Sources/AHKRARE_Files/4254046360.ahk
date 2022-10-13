sXMLget( xml, node, attr = "" ) {														;-- simple solution to get information out of xml and html

	;  by infogulch - simple solution get information out of xml and html
	;  supports getting the values from a nested nodes; does NOT support decendant/ancestor or sibling
	;  for something more than a little complex, try Titan's xpath: http://www.autohotkey.com/forum/topic17549.html

	RegExMatch( xml
      , (attr ? ("<" node "\b[^>]*\b" attr