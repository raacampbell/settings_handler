classdef settings_overloads < dynamicprops
	
	methods
		%Overload the reference and asignment operators
		function out = subsref(obj,S)
			%Overload subsref only if obj is an instance of class setting
			ind=strmatch('.',{S.type});
			out = builtin('subsref',obj, S(ind));
			S(ind)=[];

			if strcmp(class(out),'setting')

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


			%Create field if needed
			%f=fields(obj);
			%if isempty(strmatch(S(end).subs,f))
		%		fprintf('Adding property %s\n',S.subs)
		%		obj
		%		for ii=1:length(S), S(ii), end
		%		addprop(obj,S(end).subs);
		%		obj
		%		out = builtin('subsasgn',obj,S(end),settings_overloads);
		%	end


			thisObject=builtin('subsref',obj, S);
			if ~strcmp(class(thisObject),'setting')
		 		out = builtin('subsasgn',obj,S,newValue);
		 		return
		 	end

		 	userSettings = yaml.ReadYaml(obj.files.userFile);
		 	userSettings = subsasgn(userSettings,S(2:end),newValue);

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
				thisType = class(val);
				if strcmp(thisType,'setting')
					val=obj.(f{ii}).getValue;
					thisType = class(val);
				end
				s=size(val);
				out=[out,sprintf(['%',num2str(m+2),'s: [%dx%d %s]\n'],f{ii},s(1),s(2),thisType)];
        	end
        	fprintf(out)

        end %display

	end %methods

end %classdef settings_overloads 