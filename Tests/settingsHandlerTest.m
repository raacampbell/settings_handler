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
			expLeaves = 15; 
			S = settings_handler(testCase.exampleSettingsFile);
			actLeaves = length(S.settingsTree.findleaves);
 			testCase.verifyEqual(actLeaves,expLeaves);
		end % function testNumLeaves


		%Confirm that the values of everything is read as expected
		%so the hard-coded values below must match what is in the 
		%YML file.
		function testReadANumber(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			testCase.verifyEqual(S.aNumber,789)
		end

		function testReadAString(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			testCase.verifyEqual(S.aString,'hello')
		end

		function testReadSomeNumbersNoCommas(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			testCase.verifyEqual(S.someNumbersNoCommas,[11,22,95])
		end

		function testReadSomeStrings(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			testCase.verifyEqual(S.someStrings,{'hello','goodbye','help'})
		end

		function testReadPlanetColors(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			result(1) = strcmp(S.planetColors.mars,'red');
			result(2) = strcmp(S.planetColors.venus,'white');
			testCase.verifyTrue(all(result))
		end

		function testElephantMonitorFieldsNumber(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			testCase.verifyEqual(length(fields(S.elephantMonitor)),5)
		end

		function testElephantTrunkPosition(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			testCase.verifyEqual(S.elephantMonitor.trunkPosition,[10,20,30])
		end

		function testElephantTrunkSize(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			testCase.verifyEqual(S.elephantMonitor.trunkSize,32)
		end

		function testElephantLocatioXY(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			testCase.verifyEqual(S.elephantMonitor.elephantLocation.xy,5)
		end
		function testElephantLocatioZ(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			testCase.verifyEqual(S.elephantMonitor.elephantLocation.z,1)
		end





		%TODO and code to *remove* settings from the user file if they are 
		%present there but not in the default file

	end %methods (Test)

end %classdef settings_handler_Test < matlab.unittest.TestCase