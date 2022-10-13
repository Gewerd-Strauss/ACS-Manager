EnsureStartsWith(string, char) { 														;-- Ensure that the string given starts with a given char
   if ( StringLeft(string, strlen(char)) <> char )
      string := char . string

   return string
}