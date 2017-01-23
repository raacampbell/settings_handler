classdef settingsTest < matlab.unittest.TestCase

	properties
		exampleSettingsFile = './exampleSettingsFile.yml';
		userSettingsFile = './exampleUserSettings.yml';
	end %properties

	%Open test method block
	methods (Test)

		function testGetFontASizeValue(testCase)
			%Test whether a particular, hard-coded, value from the example file can be returned correctly. 
			Y=settings.yaml.ReadYaml(testCase.exampleSettingsFile);
			D=settings.yaml.ReadYaml(Y.default);

			F.defaultFile=Y.default;
			F.userFile=Y.user;

			pth={'size';'font';[]}; %This is how the path is returned from the tree 
			S=setting(F,pth,D);


			testCase.verifyEqual(S.getValue,10);

		end % function testGetFontASizeValue


		function getAllValues(testCase)
			%Test that all leaves (all stored settings) return a value
	
			Y=settings.yaml.ReadYaml(testCase.exampleSettingsFile);
			D=settings.yaml.ReadYaml(Y.default);

			F.defaultFile=Y.default;
			F.userFile=Y.user;

			S = settings_handler(testCase.exampleSettingsFile);
			L = S.settingsTree.findleaves;
			values = zeros(size(L));
			for ii=1:length(L)
				pathToRoot = S.settingsTree.pathtoroot(L(ii));
				p=S.settingsTree.Node(pathToRoot);
				thisSetting=setting(F,p,D);
				if strcmp(thisSetting.getValue,thisSetting.failureString)
					values(ii)=1;
				end
			end
			
			testCase.verifyTrue(any(values)==0)

		end % function getAllValues

        
	end %methods (Test)

end %classdef settingsTest < matlab.unittest.TestCase