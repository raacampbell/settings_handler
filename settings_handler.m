classdef settings_handler
% class settings_handler
%
% mySettings = settings_handler('mySettings.yml')
% 
% settingsFile is a yaml file that contains the location
% of the default settings file and the user-settings file. 
%
% default: exampleDefaultSettings.yml
% user: ~/exampleUserSettings.yml

% The default settings file must contain all the relevant
% setting parameters and values for them. The user file
% does not have to exist or may be partially defined. 
%
% If the user requests a setting that exists only in the
% default settings file, then it is read from that file and
% then written to the user file. 
%
% If a setting is changed, the new value is written to the 
% user file. 
%
% Each time a setting is requested, the user file is re-read.
% ADD OPTION TO SUPRESS THIS.


	properties(GetAccess='public', SetAccess='protected')
		files    %A structure containing the paths to the default settings file and the user settings file
		defaultSettings
	end

	properties(GetAccess='public', SetAccess='protected')

	end

	properties(GetAccess='public', SetAccess='public')
		userSettings
		settingsTree
	end


	methods
		function obj=settings_handler(settingsFname)
			% constructor
			% read default settings and set up user settings as needed


			if ~exist(settingsFname,'file')
				error('%s does not exits',settingsFname)
			end

			%read the yml file
			Y=yaml.ReadYaml(settingsFname);
			
			if ~exist(Y.default,'file')
				error('Can not find settings file %s\n', Y.default)
			end
			obj.files.defaultFile = Y.default;
			obj.defaultSettings = yaml.ReadYaml(obj.files.defaultFile);


			obj.files.userFile = Y.user;
			if ~exist(obj.files.userFile)
				%If the user settings file does not exist, we just copy the default settings to the desired location
				fprintf('No user settings file found at %s. Creating default file using %s\n', obj.files.userFile, obj.files.defaultFile)
				yaml.WriteYaml(obj.files.userFile, obj.defaultSettings);
			end

			%Create the structure of objects that will store the data.
			[obj.userSettings,obj.settingsTree] = makeEmptyStructAndTree(obj.defaultSettings);

		end 



	end


end






function [importedYML,T,currentBranchNode] = makeEmptyStructAndTree(importedYML,T,currentBranchNode)
	% makeEmptyStructAndTree
	%
	% Produces a tree tree (T) replicating the structure of importedYML (a struct) and also returns
	% a new version of importedYML where the values are replaced by an object of class setting.
	if nargin<2
		f=fields(importedYML);
		T = tree ;
		currentBranchNode = 1;
	end


	f=fields(importedYML);
	%fprintf('\nlooping through %d fields in %s (#%d)\n', length(f), T.Node{currentBranchNode}, currentBranchNode)

	for ii=1:length(f)

		%If we find a structure we will need to add a node
		if isstruct(importedYML.(f{ii}))
			%fprintf('\nBranching at %s', f{ii})
			[T,thisBranch] = T.addnode(currentBranchNode,f{ii});
			[importedYML.(f{ii}),T,~] = makeEmptyStructAndTree(importedYML.(f{ii}),T,thisBranch);
			continue
		end

		%fprintf('Adding %s\n', f{ii})
		[T,~] = T.addnode(currentBranchNode,f{ii});
		importedYML.(f{ii})=[];
	end
end


function p=getStructData(thisStruct,pth)

	for ii=1:length(pth)
		thisStruct=thisStruct.(pth{ii});
	end

	p=thisStruct;
end

