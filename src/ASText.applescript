(*! @abstract <em>[text]</em> ASText's name. *)
property name : "ASText"
(*! @abstract <em>[text]</em> ASText's version. *)
property version : "1.0.0"
(*! @abstract <em>[text]</em> ASText's id. *)
property id : "com.kraigparkinson.ASText"

on makeStringObj(aText)
	script StringObj
		property textValue : aText
		
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
		
			return my makeStringObj(newTextValue)
		end replaceText
	
		on removeText(textToBeRemoved)
			return replaceText(textToBeRemoved, "")
		end removeText
	
		on asText()
			return textValue
		end asText
	
		on clone()
			return my makeStringObj(textValue)
		end clone
	
		on textElements(delimeter)
			return getTextElements(textValue, delimeter)
		end textElements
	end script
	return StringObj
end makeStringObj

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

# SYNOPIS
#   doesMatch(text, regexString) -> Boolean
# DESCRIPTION
#   Matches string s against regular expression (string) regex using bash's extended regular expression language *including* 
#   support for shortcut classes such as `\d`, and assertions such as `\b`, and *returns a Boolean* to indicate if
#   there is a match or not.
#    - AppleScript's case sensitivity setting is respected; i.e., matching is case-INsensitive by default, unless inside
#      a 'considering case' block.
#    - The current user's locale is respected.
# EXAMPLE
#    my doesMatch("127.0.0.1", "^(\\d{1,3}\\.){3}\\d{1,3}$") # -> true
on doesMatch(s, regex)
    local ignoreCase, extraGrepOption
    set ignoreCase to "a" is "A"
    if ignoreCase then
        set extraGrepOption to "i"
    else
        set extraGrepOption to ""
    end if
    # Note: So that classes such as \w work with different locales, we need to set the shell's locale explicitly to the current user's.
    #       Rather than let the shell command fail we return the exit code and test for "0" to avoid having to deal with exception handling in AppleScript.
    tell me to return "0" = (do shell script "export LANG='" & user locale of (system info) & ".UTF-8'; egrep -qx" & extraGrepOption & " " & quoted form of regex & " <<< " & quoted form of s & "; printf $?")
end doesMatch


# SYNOPSIS
#   getMatch(text, regexString) -> { overallMatch[, captureGroup1Match ...] } or {}
# DESCRIPTION
#   Matches string s against regular expression (string) regex using bash's extended regular expression language and
#   *returns the matching string and substrings matching capture groups, if any.*
#   
#   - AppleScript's case sensitivity setting is respected; i.e., matching is case-INsensitive by default, unless this subroutine is called inside
#     a 'considering case' block.
#   - The current user's locale is respected.
#   
#   IMPORTANT: 
#   
#   Unlike doesMatch(), this subroutine does NOT support shortcut character classes such as \d.
#   Instead, use one of the following POSIX classes (see `man re_format`):
#       [[:alpha:]] [[:word:]] [[:lower:]] [[:upper:]] [[:ascii:]]
#       [[:alnum:]] [[:digit:]] [[:xdigit:]]
#       [[:blank:]] [[:space:]] [[:punct:]] [[:cntrl:]] 
#       [[:graph:]]  [[:print:]] 
#   
#   Also, `\b`, '\B', '\<', and '\>' are not supported; you can use `[[:<:]]` for '\<' and `[[:>:]]` for `\>`
#   
#   Always returns a *list*:
#    - an empty list, if no match is found
#    - otherwise, the first list element contains the matching string
#       - if regex contains capture groups, additional elements return the strings captured by the capture groups; note that *named* capture groups are NOT supported.
#  EXAMPLE
#       my getMatch("127.0.0.1", "^([[:digit:]]{1,3})\\.([[:digit:]]{1,3})\\.([[:digit:]]{1,3})\\.([[:digit:]]{1,3})$") # -> { "127.0.0.1", "127", "0", "0", "1" }
on getMatch(s, regex)
    local ignoreCase, extraCommand
    set ignoreCase to "a" is "A"
    if ignoreCase then
        set extraCommand to "shopt -s nocasematch; "
    else
        set extraCommand to ""
    end if
    # Note: 
    #  So that classes such as [[:alpha:]] work with different locales, we need to set the shell's locale explicitly to the current user's.
    #  Since `quoted form of` encloses its argument in single quotes, we must set compatibility option `shopt -s compat31` for the =~ operator to work.
    #  Rather than let the shell command fail we return '' in case of non-match to avoid having to deal with exception handling in AppleScript.
    tell me to do shell script "export LANG='" & user locale of (system info) & ".UTF-8'; shopt -s compat31; " & extraCommand & "[[ " & quoted form of s & " =~ " & quoted form of regex & " ]] && printf '%s\\n' \"${BASH_REMATCH[@]}\" || printf ''"
    return paragraphs of result
end getMatch
