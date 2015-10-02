classdef settingsHandlerTest < matlab.unittest.TestCase

	properties
		exampleSettingsFile = './exampleSettingsFile.yml';
		userSettingsFile = './exampleUserSettings.yml';

		exampleSettingsFile_missing = './exampleSettingsFile_missingUserSetting.yml';
		userSettingsFile_missing = './exampleUserSettings_missing.yml';
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
			%The example .yml has 16 settings in it, so there should be 16 leaves on the tree.
			expLeaves = 16; 
			S = settings_handler(testCase.exampleSettingsFile);
			actLeaves = length(S.settingsTree.findleaves);
 			testCase.verifyEqual(actLeaves,expLeaves);
		end % function testNumLeaves



		%------------------------------------------------------------------
		% read tests
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

		function testReadSomeNumbersWithCommas(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			testCase.verifyEqual(S.someNumbersWithCommas,[11,22,95])
		end

		function testReadSomeStrings(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			testCase.verifyEqual(S.someStrings,{'hello','goodbye','help'})
		end

		function testReadPlanetColors(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			result  = [strcmp(S.planetColors.mars,'red'),...
						strcmp(S.planetColors.venus,'white')];
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


		%------------------------------------------------------------------
		% Write tests
		%Confirm that we can write the different classes of value and re-read them
		%correctly.
		function testWriteANumber(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			N = 123;
			S.aNumber = N;
			testCase.verifyEqual(S.aNumber,N)
		end

		function testWriteAString(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			N = 'goodbye';
			S.aString = N;
			testCase.verifyEqual(S.aString,N)
		end

		function testWriteSomeNumbersNoCommas(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			N = [98, 76, 54];
			S.someNumbersNoCommas = N;
			testCase.verifyEqual(S.someNumbersNoCommas,N)
		end

		function testWriteSomeStrings(testCase)
			S = settings_handler(testCase.exampleSettingsFile);
			N = {'I','Need','Somebody'};
			S.someStrings = N;
			testCase.verifyEqual(S.someStrings,N)
		end


		%------------------------------------------------------------------
		% Check that we fill in missing settings from disk
		function testReadMissingNumber(testCase)
			%First confirm that the setting really not there
			Y=yaml.ReadYaml('exampleUserSettings_missing.yml');
			testCase.verifyTrue(isempty(strmatch('aNumber',fieldnames(Y))))

			%Now check that we have read it in
			S=settings_handler('./exampleSettingsFile_missingUserSetting.yml');
			testCase.verifyTrue(~isempty(strmatch('aNumber',fieldnames(S))))
		end



		%TODO and code to *remove* settings from the user file if they are 
		%present there but not in the default file

	end %methods (Test)

end %classdef settings_handler_Test < matlab.unittest.TestCase