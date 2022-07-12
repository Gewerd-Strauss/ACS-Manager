(LTrim
List-version 11.07.2022 16:29
# TODO




## Fixes
- [ ]		Seems completed, needs to be tested.			 URGENT: Fix the Structure of Snippets[] to not use the snippet name alone as Key → multiple snippets with identical name (but. f.e. different descriptions) will overwrite each other. 
	- Suggestion: make a hash-key out of the library-file 
- [ ] ~~#important: fix line 1050, or decide to #wontfix.~~ Error not reproducable right now.

- [ ] fix the RichCode highlighter not working (aka, read through the damn documentation first :P)
- [ ] Fix RegexNeedle in fParseArr() to accomodate for snippets which don't have a function-format

- [ ] Fix the bars here not wrapping properly, as well as the text somehow not wrapping properly ![[Documentation/Pasted image 20220711090346.png]]
- [ ] Fix the snippetID's not being padded when searching![[Documentation/Pasted image 20220711090843.png]] vs ![[Documentation/Pasted image 20220711090901.png]]
- [ ] Fix: Figure out how the fuck the tab3 is supposed to work - because clearly enough it does not work at all.
- [ ] - [ ] Fix: figure out why the description text of snippet 2 is cut off although there is still space left.
- [x] Fix the scriptObj- script.config.libraries.LibraryFile-reference not working.
- [x] Fix fLoadFiles to load several source-files together from script.config.libraries into the same GUI
- [x] Fix this fucking scaling here:![[Documentation/Pasted image 20220711090257.png]]
- [x] Fix lSearchSnippets searching in the unfixed file string, where snippet ID's are not aligned → must search in Snippets[]-Object Instead
## Additions
- [ ] Update scriptObj-Update()-Method to work properly with one-script-files/a repository of files.
- [ ] Decide on a RichCode-Theme
	- [ ] multi-language-support? Do I want to make this extendable beyond ahk?
- [ ] Conceptualise the Importer-GUI to go along with this - needs to give function,
	This GUI should operate on Arr.1, because they contain all info necessary.
- [ ] Search:
	- [x] search by snippetID and secID and Instr()/Regex()-searches combined
		- [ ] make the search-keys `s:` and `ID:` case-agnostic
	- remove  searchmode-DDL in favour of an Instr-Check, like having the string start with "rgx:"
	- [ ] implement regex-search
	- [ ] global commandline-search hotstring syntax to paste immediately
		- [ ] alternatively, give a ten-second gui preview to display the code
- [ ] Implement more section names, sensible ones
- [ ] figure out how to implement a proper fuzzy search algorithm
- [ ] give this damn thing a name (ahk common?)
- [ ] Create a logo for this whole charade
- [ ] allow pointers to gists for updating remote libs 
- [ ] Attach tooltips to various controls
- [ ] Figure out how to make the GUI resizable
	- [ ] set lower limits for minimum required sensible size yet
- [ ] finish the statusbar - add meaningful info (author, version, size and position, \#NumberOfLoadedLibraries), and utility as buttons (update default library from online gist (as is done in GHB) - write downloader, file-checker and update-routine(utilise script.update to check for version diff as well) 
- [ ] create a bootup message (comparable to the loadup-visual of ahkrare - indexing all files)
- [ ] #important finish up references/rewrite personal versions of usable code.
- [x] DEPRECATED: removed from scope: Figure out why the groupbox is killing the tab control.
- [x] Add additional RichEditFields (at least for examples) _in_principle?
- [x] Edit Logic acc to the format seen here: AHK-Code-Snippets\AHK_LibraryGUI - how to format description and example block.PNG
	- [x] then edit the FillFields-function to cut out these blocks from the Code-Section, and add them to the respective other edits
---

## Importer GUI
Create a GUI to allow manual addition of code-snippets
- must be able to rewrite the library-files to insert before the section-list-delimiter

GUI requires:
- [ ] add snippet
	- [ ] give name, long description, short, code, section

## Edit Snippet GUI
GUI requires:
- [ ] edit snippet  
	- [ ] rename 
	- [ ] move to section / change Section number, but keep index
	- [ ] edit code
	- [ ] edit short description
	- [ ] edit long description
	- [ ] edit example section
	- [ ] move to section
	- [ ] delete snippet    

### Internal Dev:
- [ ] Write Importer-Script to import from ahkrare-lib
	- [ ] will probably be painful as fuck, although I should be able to get the strings incrementally-cleaned, and then just manually add indices and keep them within a separate file.




# various notes for development:


In the end, you can just
- map out the order of the snippets by index (optional)
- concatenate to a complete string (arr.1.[fn].Code contains the entire snippet section, including required newlines)

- consider rewriting the handler as a class-derived Obj instead: 

)