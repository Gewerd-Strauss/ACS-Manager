StrDiff(str1, str2, maxOffset:=5) {													;-- SIFT3 : Super Fast and Accurate string distance algorithm
	if (str1 = str2)
		return (str1 == str2 ? 0/1 : 0.2/StrLen(str1))
	if (str1 = "" || str2 = "")
		return (str1 = str2 ? 0/1 : 1/1)
	StringSplit, n, str1
	StringSplit, m, str2
	ni := 1, mi := 1, lcs := 0
	while ((ni <= n0) && (mi <= m0)) {
		if (n%ni% == m%mi%)
			lcs += 1
		else if (n%ni% = m%mi%)
			lcs += 0.8
		else {
			Loop, % maxOffset {
				oi := ni + A_Index, pi := mi + A_Index
				if ((n%oi% = m%mi%) && (oi <= n0)) {
					ni := oi, lcs += (n%oi% == m%mi% ? 1 : 0.8)
					break
				}
				if ((n%ni% = m%pi%) && (pi <= m0)) {
					mi := pi, lcs += (n%ni% == m%pi% ? 1 : 0.8)
					break
				}
			}
		}
		ni += 1
		mi += 1
	}
	return ((n0 + m0)/2 - lcs) / (n0 > m0 ? n0 : m0)
}