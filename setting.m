classdef setting
% setting(files,pathToVariable,defaultSettings)

	properties
		files  %Contains the location of the user settings and default settings yml
		pathToVariable %Path to the variable in the imported structure
		defaultSettings %Structure of already imported default settings. 
		failureString 
	end


	methods
		function obj=setting(files,pathToVariable,defaultSettings)
			obj.files = files; 
			pathToVariable(end) = [];
			obj.pathToVariable = flipud(pathToVariable);
			obj.defaultSettings = defaultSettings;
			obj.failureString = '  -NOT FOUND-  ';
		end

		function value=getValue(obj)
			%read the user settings
			userSettings=yaml.ReadYaml(obj.files.userFile);

			value=getStructData(userSettings,obj.pathToVariable);
			if strcmp(value,obj.failureString);
				value=getStructData(obj.defaultSettings,obj.pathToVariable);
			end

			%generate error if we still have not found the variable.
			if strcmp(value,obj.failureString);
				pth = '';
				for ii=1:length(obj.pathToVariable)
					pth = [pth, obj.pathToVariable{ii},'.'];
				end
				pth(end)=[]
				error('Can not find %s in user settings or default settings\n',pth)
			end



		end

	end %methods

end %classdef setting



function p=getStructData(thisStruct,pth)
	%Return the value of a variable in a structure given the path to the variable
	%which is defined in a cell array. 
	% e.g. to return the 8 we do:
	% myStruct.thisVar.blob = 8;
	% getStructData(myStruct,{'thisVar','blob'}) 


	for ii=1:length(pth)
		if isfield(thisStruct,pth{ii})
			thisStruct=thisStruct.(pth{ii});
		else
			p='  -NOT FOUND-  ';
			return			
		end
	end

	p=thisStruct;
end
