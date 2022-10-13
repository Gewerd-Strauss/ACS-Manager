EnsureEndsWith(string, char) {  														;-- Ensure that the string given ends with a given char

   if ( StringRight(string, strlen(char)) <> char )
      string .= char

   return string
}