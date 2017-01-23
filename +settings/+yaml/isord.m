function result = isord(obj)
import settings.yaml.*;
result = ~iscell(obj) && any(size(obj) > 1);
end
