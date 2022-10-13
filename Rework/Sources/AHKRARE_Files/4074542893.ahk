Replicate( Chr=" ", X:=1 ) {                                                           	;-- replicates one char x-times
Return VarSetCapacity( V, VarSetCapacity(V,VarSetCapacity(V,64)>>32)+X, Asc(Chr) ) ? V :
}