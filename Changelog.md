# Changelog
v. 13.07.2022-3
- removed some irrelevant code
- added hostring `alib.s` to open GUI- added hostring `alib.s` to open GUI^[previously only possible via Numpad0, which is kinda hard on a mobile 13"-laptop]
- added a few comments on particularly weird stuff, or todo's for later
- renamed `f_IncorporateHash` to `f_IncorporateHashAndFilename`
- moved code out of `f_IncorporateHashAndFileName` into `f_AddHashedFilePath`  - not entirely happy with the current solution either
- added `CodeTimer()` to benchmark the bootup process
- renamed `fCreateIniObj()` to `fCreateSectionNames()` because it has really _nothing to do with an Ini-Object anymore.
- removed unused ini-files

---
v.13.07.2022-2
- removed various instances of clipboard overwriting for testing reasons. Still left in code for possible debug later on, but right now disabled.
- added Library-Name to the Listview. Might make it hidable because the information it gives is limited, and only really relevant when you need to figure out where a snippet is located. For that however I could just as well straight out output the snippet-object or just have the file open automatically.
- [x] fixed bug introduced in v.13.07.2022-1 which made a regex-needle unusable.
---
v.13.07.2022-1
- [x] Collect all regex needles in an object at script-start to prevent accidental variation between occurences
- [x] fix the RichCode highlighter not working
---
v.12.07.2022-2
- [ ] tested updater, currently apparently bugged to create unreadable library-files when used to download them.
- [x] fixed needles not removing description/example blocks


- removed old test files

---
v.12.07.2022-1
Additions: 
- [x] search by snippetID and secID and Instr()/Regex()-searches combined

Fixes
- [x] Fix lSearchSnippets searching in the unfixed file string, where snippet ID's are not aligned → must search in Snippets[]-Object Instead
- [x] Fix fLoadFiles to load several source-files together from script.config.libraries into the same GUI

---
v.11.07.2022-3
- fixed GUI not autofocussing on LV when reopening.
- fixed snippets with identical names overwriting each other by creating unique hashes as identifying keys instead of snippet-name
- removed unnecessary code
- fixed searching by ID working properly, but feeding the wrong ID into the listview when displaying the result




---
v.11.07.2022-2
- build up overview on scope I intend to reach. Stuff might be added or cut from that roadmap as I progress.
---
v.11.07.2022-1
- made gui completely scaleable (have not set lower limits for minimum required sensible size yet)
	- fixed some scaling shenanigans
- [x] Fix this fucking scaling here:![[Documentation/Pasted image 20220711090257.png]]
---
v.10.07.2022-1
- various bugfixes

Additions
- added sorting array in LV based on Section
- added support to load from multiple files simultaneously
	- each file can start indexing at 1 to be usable alone as well. The script aligns snippet indices across all included files when booting up, and uses those as reference
- added mode to continuously number snippets in their respective sections from 1-n. Might disable the legacy mode at some point.
- allows searching by `Index` and `SectionID`: search by key `ID:%Number%` to search by snippet index, and use search "s:Number" to search for a specific section. Currently no combination with other search parameters are possible, but it is intended.SectionID-searching does not allow searching by section `ID:%SectionName%`
- displays number of loaded snippets, as well as number of matches when searching
- index now padded to the length of the number `Snippets.Count()`
- added several library files to test library merging.

Misc
- changelog arbitrarily started now. Versioning arbitrarily started now, following format dd.MM.yyyy-Commit


---

v0.1 - v10.07.2022-3
- basic build. 