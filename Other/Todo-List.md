(LTrim
List-version 31.07.2022 21:18:35
# TODO
- [ ] #important **Finish Hashing-Checker (and script-specific update routine, as scriptobj is no longer suitable for that**
- [ ] Consider switching storage over to something like JSON, (or rather SerDes in this case) both make my life much easier when loading the data, and when parsing it - because there is basically nothing to parse
	- considerations: 
		- 1 SerDes-Str/File, so that we don't loose file-relative hash uniqueness
		- Hash must be created based upon something other, maybe based upon FileInd?
		- make sure that the integrity of Snippets[] remains intact, otherwhise I'll have to rewrite about 90%
		- Create a snippet's Save Function which takes Snippets and "FIlePath" as inputs, then only collects all Snippets.entries which are from said file, then push all of that to SerDes and write to a new file, to translate the syntax'
			- after that, you should only be able to add new snippets by AdditionGui/GUI2, which will incorporate the respective input into the chosen file's Object, then save the respective string to file again. 
		- consider splitting code and metadata (but why, if we're already using serdes?)
	- [ ] Consider instead using the approach outlined by anonymous1184, which will result in a massive increase of files (~k_Snippets\*3), but reduce loadup times because I no longer require parsing or any regexes - just read the files set by set and populate LV accordingly (CodeFile and MetadataFile must both be read per snippet for the LV, and ExampleLong/DescriptionLong must only be read when selecting a file)
		- additionally, this can be sped up by storing all snippets in library FOLDERS, with structure
			[Library]→[SnippetHash]→[snippet.ahk,snippet.meta.ini,snippet.desk.ini]
		- this keeps the ability to quickly copy an entire library (which might be contextually related), while still largely reducing looping and formatting time.
		- not sure if I still would populate an array to store the data, or not. 
	
- [x] Figure out what's the best step forward regarding speed - which largely depends on how many loops I require. → benched for now, let's get the first prototype done before we actually start thinking about performance stuff
- [ ] Figure out how to drastically reduce the amount of loops required to do this. 
	- moved back to when this is feature-complete **||** **NOTE: RELAY UNTIL FINAL STORAGE SOLUTION IS DONE - WE DON'T WANT TO HAVE TO REDO THIS TWICE**
- [ ] hunt down the most reasonable performance gains wherever possible, refer to https://www.autohotkey.com/boards/viewtopic.php?t=6413 for overview and go from there. **||** **NOTE: RELAY UNTIL FINAL STORAGE SOLUTION IS DONE - WE DON'T WANT TO HAVE TO REDO THIS TWICE**

## Fixes
- [ ] ~~#important: fix line 1050, or decide to #wontfix.~~ Error not reproducable right now.





- [ ] Make the GUI _actually_ scaleable via AutoXYWH or similar solutions.
- [ ] Fix the Clipboard Inspection to
	- act whenever 
		- ~~snippet is copied~~ (done)
		- GUI is shown
			- to do so, look for the ";--uID:Hash_\d*"-string which _would_ have to be at the end of the clipboard string. In that case, strsplit(Clipboard,";--uID:Hash_).2 will yield only the Hash value itself. If that is clean (i.e. does not contain text after it), check it against the loaded snippets via Snippets.HasKey("Hash_\d*"). If that returns true, note the snippetname and update the message. If not, note that clipboard does not contain snippet from this script.


- [x] Fix this fucking scaling here:![[Documentation/Pasted image 20220711090257.png]]
- [x] Fix: Clicking the Descriptionbox will copy the currently selected Snippet
- [x] Fix: Single-clicking an item in the LV will not populate the DescriptionBox/RC-Fields, double-clicking was required
- [x] Fix: Figure out how the fuck the tab3 is supposed to work - because clearly enough it does not work at all.
- [x] Fix the bars here not wrapping properly, as well as the text somehow not wrapping properly ![[Documentation/Pasted image 20220711090346.png]]
- [x] Fix: figure out why the description text of snippet 2 is cut off although there is still space left.
- [x] at 1080 screen sizing the richEdit-fields will cut over the boundary of the tab control
- [x] at 1080 screen sizing the textfield of the red "xx snippets loaded" will cut over the boundary of the groupbox control
- [x] Fix: #important regex.Description and Regex.Example does not seem to work uniformly.
	- specifically: any description or example fields in the first-to-be-loaded file will not be found and treated properly. For unknown-to-me reasons, the fields are only correctly found and removed/ingested from file2 onwards)
		- #important fixed by force-converting "\`r\`n" to "\`n" immediately after `FileRead()`. I have no clue why these identical files are being read back with different newline formatting, but they are. Might be some include changing formatting behaviour of ahk?? Check up on that idea.
- [x]		Seems completed, needs to be tested.			 URGENT: Fix the Structure of Snippets[] to not use the snippet name alone as Key → multiple snippets with identical name (but. f.e. different descriptions) will overwrite each other. 
	- Suggestion: make a hash-key out of the library-file 

- [X] Fix: Search cannot combine ID-/S- and string-Search in random orders 
- [X] Fix: Search cannot combine ID-/S- and Regex-Search in random orders 
- [x] Fix the snippetID's not being padded when searching![[Documentation/Pasted image 20220711090843.png]] vs ![[Documentation/Pasted image 20220711090901.png]]
- [x] #important - fix the ID-regex trimming preceeding zeros, which makes looking for low integer indexed snippets difficult if there are many snippets, because they are _all_ getting found.
- [x] Fix RegexNeedle in fParseArr() to accomodate for snippets which don't have a function-format
- [x] fix the RichCode highlighter not working (aka, read through the damn documentation first :P)
- [x] Fix the scriptObj- script.config.libraries.LibraryFile-reference not working.
- [x] Fix fLoadFiles to load several source-files together from script.config.libraries into the same GUI
- [x] Fix lSearchSnippets searching in the unfixed file string, where snippet ID's are not aligned → must search in Snippets[]-Object Instead
## Additions

### _Updating Snippets from remote_
- [ ] #important Update scriptObj-Update()-Method to work properly with one-script-files/a repository of files. 
	- [ ] this includes making more extensive tests
	- [ ] creating a backup folder of the pre-update instance including all files within the folder/zip script-directory into a backup within script-dir and then overwrite all files.
	- [ ] allow pointers to gists for updating remote libs 
	- **in principle finished, but not extensively checked yet.**


### _Creating/Adding Snippets_
- [ ] Conceptualise the Importer-GUI to go along with this - cf Section "Importer GUI" for more information	**||** **NOTE: RELAY UNTIL FINAL STORAGE SOLUTION IS DONE - WE DON'T WANT TO HAVE TO REDO THIS TWICE**
	

### _Searching_
- [ ] figure out how to implement a proper fuzzy search algorithm **||** **NOTE: RELAY UNTIL FINAL STORAGE SOLUTION IS DONE - WE DON'T WANT TO HAVE TO REDO THIS TWICE**
	- [ ] finish up the implementation of FuzzySearch for InStr-Search - not sure how the function itself exactly calculates its result. 
- [ ] remove  searchmode-DDL in favour of an Instr-Check, like having the string start with "rgx:"  **||** **NOTE: NOT SURE IF WORTH IT; AS IT MAKES THE SEARCH BOX EVEN MORE CLUTTERED. MIGHT BE GREAT FOR CLI-INSTANCE THOUGH.**





### _Misc_
- [ ] figure out how to name the file an error is thrown from (as in, how to distinguish between the mainscript and any potential #Include - then incorporate into scriptObj) **||** **SIDEPROJECT ON SCRIPTOBJ, NOT RELEVANT HERE**
	- [ ] finish updating the debug-fn from scriptobj. Keep on the old f_ThrowError till then.
- [ ] Implement more section names, sensible ones **||** **NOTE: RELAY UNTIL FINAL STORAGE SOLUTION IS DONE - WE DON'T WANT TO HAVE TO REDO THIS TWICE**
	- [ ] ~~set lower limits for minimum required sensible size yet~~ best additions are those you don't recall the purpose for.
- [ ] Figure out how to make the GUI resizable → **AutoXYWH can be used I believe, but I'll have to overlook it so far.**

### _Misc - Touchups_ - to be done once everything else is finished, as they are way too low priority while still being probably drastically influenced by structural changes.
- [ ] global commandline-search hotstring syntax to paste immediately **||** **NOTE: RELAY UNTIL FINAL STORAGE SOLUTION IS DONE - WE DON'T WANT TO HAVE TO REDO THIS TWICE**
	- [ ] alternatively, give a ten-second gui preview to display the code
- [ ] finish the statusbar - add meaningful info (author, version, size and position, \#NumberOfLoadedLibraries), and utility as buttons (update default library from online gist (as is done in GHB) - write downloader, file-checker and update-routine(utilise script.update to check for version diff as well) 

### _low prio_	- can wait till everything else is done.
- [ ] Create a logo for this whole charade
- [ ] give this damn thing a name?!
- [ ] create a bootup message (comparable to the loadup-visual of ahkrare - indexing all files) **||** **fundamentally flawed because this script doesn't populate incrementally, instead performes steps one by one.**
- [ ] think about combining more steps per loop, so we can reduce # of loops
- [ ] figure out how to fuzzy-approach s:[[SectionName]] searches, when you don't know the section's ID - maybe use a TT as done by Hotstrings.ahk by mslonik to display potential matches, and just have the hotstrings be converted from there?
	- alternatively: 
		- make a set of hotstrings (which are only active in the search box?), which will replace s:[[gui - menu]] with s:11 and uses a proximity alg to fuzzy-preview potential section names when typing.


### _Done_
- [x] add warning when combining fuzzy and regex search as the fuzzy serch is ignored in that case.
- [x] Attach tooltips to various controls
- [x] implement regex-search
- [x] search by snippetID and secID and Instr()/Regex()-searches combined
	- [x] make the search-keys `s:` and `ID:` case-agnostic
- [x] Incorporate Library-Name into Snippet Info during fParseSnippet, then populate the LV field respectively. 
	- [x] done in principle, but must be verified to not introduce bugs somewhere else
	- [x] Consideration to make: Might make it hidable because the information it gives is limited, and only really relevant when you need to figure out where a snippet is located. For that however I could just as well straight out output the snippet-object or just have the file open automatically.
- [x] Decide on a RichCode-Theme
	- [x] ~~multi-language-support? Do I want to make this extendable beyond ahk?~~
- [x] Collect all regex needles in an object at script-start to prevent accidental variation between occurences
- [x] Add additional RichEditFields (at least for examples) _in_principle?
- [x] Edit Logic acc to the format seen here: AHK-Code-Snippets\AHK_LibraryGUI - how to format description and example block.PNG
	- [x] then edit the FillFields-function to cut out these blocks from the Code-Section, and add them to the respective other edits

- [ ] DEPRECATED: ~~finish up a coherent error interpreter, with global and unique error codes displayed in 1st RC-field~~  error's collected and thrown with `scriptobj` instead
- [] DEPRECATED: removed from scope: Figure out why the groupbox is killing the tab control.


- [ ] UNCLEAR ~~#important finish up references/rewrite personal versions of usable code.~~ | What was the point of this?

---
---
Hash_1420113362 ;; this is just here for quicker testing purposes

## Import Snippet GUI
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

# Internal Dev:
- [ ] Write Importer-Script to import from ahkrare-lib **||** **NOTE: RELAY UNTIL FINAL STORAGE SOLUTION IS DONE - WE DON'T WANT TO HAVE TO REDO THIS TWICE**
	- [ ] will probably be painful as fuck, although I should be able to get the strings incrementally-cleaned, and then just manually add indices and keep them within a separate file. 
		- [ ] issue: how to deal with subsections? CUrrently not implemented, and the solution might look different depending on whether or not this is done multiple snippets/lib ←→ 3files/lib




# various notes for development:


In the end, you can just
- map out the order of the snippets by index (optional)
- concatenate to a complete string (arr.1.[fn].Code contains the entire snippet section, including required newlines)

- consider rewriting the handler as a class-derived Obj instead: 

)