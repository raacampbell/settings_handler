function result = disp(data)
% result = disp(data)
% Display mix of cells and structures in YAML format.
% A shortcut to yaml.WriteYaml('',x).

if nargout == 0
  settings.yaml.WriteYaml('',data)
else
  result = settings.yaml.WriteYaml('',data);
end

end