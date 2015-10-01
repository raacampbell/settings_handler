classdef settingsHandlerTest < matlab.unittest.TestCase

	properties
		exampleSettingsFile = './exampleSettingsFile.yml';
		userSettingsFile = './exampleUserSettings.yml';
	end %properties

	%Open test method block
	methods (Test)

		function testDefaultSettingsFileCreation(testCase)
			%Does settings_handler correctly create a new user settings file when none previously existed?
			if exist(testCase.userSettingsFile)
				delete(testCase.userSettingsFile)
			end
			S = settings_handler('exampleSettingsFile.yml');
 			testCase.verifyTrue(exist(testCase.userSettingsFile,'file')==2)

		end % function testDefaultSettingsFileCreation
		
		function testNumLeaves(testCase)
			%The example .yml has 20 settings in it, so there should be 20 leaves on the tree.
			expLeaves = 20; 
			S = settings_handler(testCase.exampleSettingsFile);
			actLeaves = length(S.settingsTree.findleaves);
 			testCase.verifyEqual(actLeaves,expLeaves);
		end % function testNumLeaves

	end %methods (Test)

end %classdef settings_handler_Test < matlab.unittest.TestCase