classdef settingsHandlerTest < matlab.unittest.TestCase

	%properties
%		exampleSettingsFile = '../example_settings/exampleSettingsFile.yml';
	%end
	%Open test method block
	methods (Test)
		function testNumLeaves(testCase)
			%The example .yml has 20 settings in it, so there should be 
			%20 leaves on the tree.
			expLeaves = 20; 
			%S = settings_handler('exampleSettingsFile.yml');
 			actLeaves = 20;%length(S.settingsTree.findleaves);
 			testCase.verifyEqual(actLeaves,expLeaves);
		end % function testNumLeaves(testCase)
	end %methods (Test)


end %classdef settings_handler_Test < matlab.unittest.TestCase