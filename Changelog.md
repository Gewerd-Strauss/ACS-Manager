Changelog

v.11.07.2022-1



v.10.07.2022-1
- various bugfixes

---

Additions
- added sorting array in LV based on Section
- added support to load from multiple files simultaneously
	- each file can start indexing at 1 to be usable alone as well. The script aligns snippet indices across all included files when booting up, and uses those as reference
- added mode to continuously number snippets in their respective sections from 1-n. Might disable the legacy mode at some point.
- allows searching by `Index` and `SectionID`: search by key `ID:%Number%` to search by snippet index, and use search "s:Number" to search for a specific section. Currently no combination with other search parameters are possible, but it is intended.SectionID-searching does not allow searching by section `ID:%SectionName%`
- displays number of loaded snippets, as well as number of matches when searching
- index now padded to the length of the number `Snippets.Count()`
- added several library files to test library merging.

---

- changelog arbitrarily started now. Versioning arbitrarily started now, following format dd.MM.yyyy-Commit

---
---

v0.1 - v10.07.2022-3
- basic build. 