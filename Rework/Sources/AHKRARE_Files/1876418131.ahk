TV_Find(VarText) {																										;-- returns the ID of an item based on the text of the item

Loop {
ItemID := TV_GetNext(ItemID, "Full")
if not ItemID
	break
TV_GetText(ItemText, ItemID)
If (ItemText=VarText)
	Return ItemID
}

Return
}