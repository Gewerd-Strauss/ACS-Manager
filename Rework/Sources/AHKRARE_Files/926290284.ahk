Acc_ChildrenByRole(Acc, Role) {		;--
   if ComObjType(Acc,"Name")!="IAccessible"
      ErrorLevel := "Invalid IAccessible Object"
   else {
      Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
      if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
         Loop %cChildren% {
            i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i)
            if NumGet(varChildren,i-8)=9
               AccChild:=Acc_Query(child), ObjRelease(child), Acc_Role(AccChild)=Role?Children.Insert(AccChild):
            else
               Acc_Role(Acc, child)=Role?Children.Insert(child):
         }
         return Children.MaxIndex()?Children:, ErrorLevel:=0
      } else
         ErrorLevel := "AccessibleChildren DllCall Failed"
   }
   if Acc_Error()
      throw Exception(ErrorLevel,-1)
}