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
		
	end script	
	
end script
