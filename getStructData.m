
function p=getStructData(thisStruct,pth)
	%Return the value of a variable in a structure given the path to the variable
	%which is defined in a cell array. 
	% e.g. to return the 8 we do:
	% myStruct.thisVar.blob = 8;
	% getStructData(myStruct,{'thisVar','blob'}) 
	%
	% TODO: make this private for the classes setting and settings_handler

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
