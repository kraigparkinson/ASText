(*!
	@header ASText
		ASText self tests.
	@abstract License: GNU GPL, see COPYING for details.
	@author Kraig Parkinson
	@copyright 2015 kraigparkinson
*)

property ASText : script "com.kraigparkinson/ASText"
use ASUnit : script "com.lifepillar/ASUnit"

property parent : ASUnit
property suite : makeTestSuite("AS Text")
--autorun(suite)

my autorun(suite)

script |ASText|
	property parent : TestSet(me)
	
	on setUp()
	end setUp
	
	on tearDown()
	end tearDown
	
	script |single delimeters|
		property parent : UnitTest(me)
		
		set theText to "foo, bar, fun,"
		set theElements to ASText's getTextElements(theText, ", ")
		shouldEqual(3, count of theElements)
		shouldEqual("foo", item 1 of theElements)
		shouldEqual("bar", item 2 of theElements)
		shouldEqual("fun,", item 3 of theElements)

		set theText to "! :: @ # # $ //"
		set theElements to ASText's getTextElements(theText, space)
		shouldEqual(7, count of theElements)
		shouldEqual("!", item 1 of theElements)
		shouldEqual("::", item 2 of theElements)
		shouldEqual("@", item 3 of theElements)
		
	end script	

	script |missing value returns empty|
		property parent : UnitTest(me)
		
		set theElements to ASText's getTextElements(missing value, ":")
		shouldEqual(0, count of theElements)
	end script
	
end script

script |StringObj|
	property parent : TestSet(me)
	
	on setUp()
	end setUp
	
	on tearDown()
	end tearDown
	
	script |as text|
		property parent : UnitTest(me)
		
		set aString to ASText's StringObj's makeString("Some text")
		shouldEqual("Some text", aString's asText())
	end script

	script |replace text|
		property parent : UnitTest(me)
		
		set aString to ASText's StringObj's makeString("Some text")
		set aString to aString's replaceText(space, "")
		shouldEqual("Sometext", aString's asText())
	end script
	
	script |remove text|
		property parent : UnitTest(me)
		
		set aString to ASText's StringObj's makeString("Some text")
		set aString to aString's removeText(" text")
		shouldEqual("Some", aString's asText())
	end script
end script
