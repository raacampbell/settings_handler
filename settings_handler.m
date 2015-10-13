classdef settings_handler < dynamicprops
% settings_handler - transparent YML settings file read/writer
%
% class settings_handler(settingsFname)
%
%
% Purpose
% settings_handler is a class for handling persistant user settings in a way
% that is transparent to the user. settings_handler reads a YAML file that 
% defines the location of a default settings file and a user settings file 
% where modification can be made. 
%
% settings_handler creates what outwardly looks like a structure (settings 
% may be nested in a tree-like fashion) containing the user settings from the 
% YML file. In reality, each value in the structure is an object that handles 
% reading and writing to the YML file on disk. The following are then possible:
% 1. Each time a value is accessed, it is read from disk.
% 2. If a value is re-assigned, it is immediately written to disk.
% 3. If the user-specific settings file does not exist, it is automatically 
%    created from the default file.
% 4. If a setting exists in the default settings file and not the user file, 
%    the value in the default file is automatically read. If this value is 
%    modified, the modified value is written to the user settings file.
%
%
% Example
% mySettings = settings_handler('mySettings.yml')
% see also: ./examples/example_one
%
%
% Rob Campbell - Basel 2015

	properties(GetAccess='public', SetAccess='protected')

	end

	properties(GetAccess='protected', SetAccess='protected')
		files    %A structure containing the paths to the default settings file and the user settings file
		defaultSettings
		settingsTree
		userSettings
	end

	properties(GetAccess='public', SetAccess='public')
		
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
			[userSettings,obj.settingsTree] = obj.makeEmptyStructAndTree(obj.defaultSettings);
			f=fields(userSettings);
			for ii=1:length(f)
				addprop(obj,f{ii});
				obj.(f{ii}) = userSettings.(f{ii});
			end
			obj.userSettings=userSettings;


			%TODO: remove stuff from user settings that is not in default settings


		end %function settings_handler [constructor]


		%Overload the reference and asignment operators
		function out = subsref(obj,S)
			%Overload subsref only if obj is an instance of class setting

			if strcmp(S(1).subs,'settingsTree')
				out = builtin('subsref',obj, S);
				return
			end


			ind=strmatch('.',{S.type});
			out = builtin('subsref',obj, S(ind));
			S(ind)=[];

			if isa(out,'setting')
				%Indexes the value if the user attempted to do this
				out=out.getValue;
				if ~isempty(S)
					for ii=1:length(S)
						out=subsref(out,S(ii));
					end
				end

			end
		end %function subsref


	 	function out=subsasgn(obj,S,newValue)
			%Overload subsref only if obj is an instance of class setting

			thisObject=builtin('subsref',obj, S);
			if ~isa(thisObject,'setting')
		 		out = builtin('subsasgn',obj,S,newValue);
		 		return
		 	end

		 	userSettings = yaml.ReadYaml(obj.files.userFile);

		 	userSettings = subsasgn(userSettings,S,newValue);

		 	yaml.WriteYaml(obj.files.userFile,userSettings);

		 	out=obj;

        end

        function display(obj)
        	%overload display so setting class is displayed as being the same class as the value it stores
        	%TODO: doesn't work on child setting instances that are attached a structure and not to the settings_handler object
        	f=sort(fields(obj));
        	m=max(cellfun(@length,f));
        	out='';
        	for ii=1:length(f)
				val=obj.(f{ii});
				if isa(val,'setting')
					val=obj.(f{ii}).getValue;
				end
				s=size(val);
				out=[out,sprintf(['%',num2str(m+2),'s: [%dx%d %s]\n'],f{ii},s(1),s(2),class(thisType))];
        	end
        	fprintf(out)

        end %display
	end %methods

	methods (Access='protected')

		function [importedYML,T,currentBranchNode] = makeEmptyStructAndTree(obj,importedYML,T,currentBranchNode)
			% makeEmptyStructAndTree
			%
			% Produces a tree tree (T) replicating the structure of importedYML (a struct) and also returns
			% a new version of importedYML where the values are replaced by an object of class setting.

			verbose = 0; %switch to 1 to debug 

			if nargin<3
				f=fields(importedYML);
				T = tree ;
				currentBranchNode = 1;
			end

			f=fields(importedYML);
			if verbose
				fprintf('\nlooping through %d fields in %s (#%d)\n',...
				length(f), T.Node{currentBranchNode}, currentBranchNode)
			end

			for ii=1:length(f)

				%If we find a structure we will need to add a node
				if isstruct(importedYML.(f{ii}))
					if verbose
						fprintf('\nBranching at %s', f{ii})
					end
					[T,thisBranch] = T.addnode(currentBranchNode,f{ii});
					[importedYML.(f{ii}),T,~] = obj.makeEmptyStructAndTree(importedYML.(f{ii}),T,thisBranch);
					continue
				end

				if verbose
					fprintf('Adding %s\n', f{ii})
				end

				[T,thisNode] = T.addnode(currentBranchNode,f{ii});
				pth = T.Node(T.pathtoroot(thisNode));
				importedYML.(f{ii})=setting(obj.files,pth,obj.defaultSettings);
			end
		end % function makeEmptyStructAndTree


	end %protected methods


end %classdef settings_handler
