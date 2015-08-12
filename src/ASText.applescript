(*! @abstract <em>[text]</em> ASText's name. *)
property name : "ASText"
(*! @abstract <em>[text]</em> ASText's version. *)
property version : "1.0.0"
(*! @abstract <em>[text]</em> ASText's id. *)
property id : "com.kraigparkinson.ASText"

on getTextElements(theText, delimeter)
	local textElements
	
	set prevTIDs to text item delimiters of AppleScript
	try
		set text item delimiters of AppleScript to delimeter
		set textElements to every text item of theText
	on error
		set text item delimiters of AppleScript to prevTIDs
	end try
	
	set text item delimiters of AppleScript to prevTIDs
	return textElements
end getTextElements

on replaceChars(this_text, search_string, replacement_string)
	
	set prevTIDs to text item delimiters of AppleScript
	
	try
		set AppleScript's text item delimiters to the search_string
		set the item_list to every text item of this_text
		
		set AppleScript's text item delimiters to the replacement_string
		set this_text to the item_list as string
		set AppleScript's text item delimiters to prevTIDs
	on error
		set AppleScript's text item delimiters to prevTIDs
	end try
	
	return this_text
end replaceChars


-- From Nigel Garvey's CSV-to-list converter
-- http://macscripter.net/viewtopic.php?pid=125444#p125444
on trim(txt, trimming)
	if (trimming) then
		repeat with i from 1 to (count txt) - 1
			if (txt begins with space) then
				set txt to text 2 thru -1 of txt
			else
				exit repeat
			end if
		end repeat
		repeat with i from 1 to (count txt) - 1
			if (txt ends with space) then
				set txt to text 1 thru -2 of txt
			else
				exit repeat
			end if
		end repeat
		if (txt is space) then set txt to ""
	end if
	
	return txt
end trim

on stripWhitespace(textValue)
	return textValue
end stripWhitespace


