function fdelete(varargin)
	for i = 1:nargin
		file = varargin{i};
		if exist(file,'file')
			delete(file);
		end
	end
end
