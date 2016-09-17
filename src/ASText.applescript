(*! @abstract <em>[text]</em> ASText's name. *)
property name : "ASText"
(*! @abstract <em>[text]</em> ASText's version. *)
property version : "1.0.0"
(*! @abstract <em>[text]</em> ASText's id. *)
property id : "com.kraigparkinson.ASText"

script StringObj
	property parent : missing value
	property textValue : missing value
	
	on make new StringObj with data theText
		return makeString(theText)
	end make
	
	on makeString(theText)
		copy StringObj to aString
		set aString's textValue to theText
		return aString
	end makeString

	on indexof(theText)
		return offset of theText in textValue
	end indexof
	
	on replaceText(oldText, newText)
		local newTextValue
		if (oldText equals newText) then return me
		
		set prevTIDs to text item delimiters of AppleScript
	
		try
			set AppleScript's text item delimiters to oldText
			set the item_list to every text item of textValue
		
			set AppleScript's text item delimiters to newText
			set newTextValue to the item_list as string
			set AppleScript's text item delimiters to prevTIDs
		on error
			set AppleScript's text item delimiters to prevTIDs
		end try
		
		return makeString(newTextValue)
	end replaceText
	
	on removeText(textToBeRemoved)
		return replaceText(textToBeRemoved, "")
	end removeText
	
	on asText()
		return textValue
	end asText
	
	on clone()
		return makeString(textValue)
	end clone
	
	on textElements(delimeter)
		return getTextElements(textValue, delimeter)
	end textElements
end script

on makeString(theText)
	copy StringObj to aString
	set aString's textValue to theText
	return aString
end makeString

on getTextElements(theText, delimeter)
	set textElements to { }

	if (theText is not missing value)
		
		set prevTIDs to text item delimiters of AppleScript
		try
			set text item delimiters of AppleScript to delimeter
			set textElements to every text item of theText
		on error 
			set text item delimiters of AppleScript to prevTIDs
			error
		end try
	
		set text item delimiters of AppleScript to prevTIDs
	end if
	return textElements
end getTextElements

on replaceText(input, x, y)
    set text item delimiters to x
    set ti to text items of input
    set text item delimiters to y
    ti as text
end replaceText

on split(input, x)
    if input does not contain x then return {input}
    set text item delimiters to x
    text items of input
end split

on join(input, x)
    set text item delimiters to x
    input as text
end join

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


