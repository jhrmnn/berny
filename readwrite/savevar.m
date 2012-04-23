function var = savevar(varargin)
	for i = 1:nargin
		var.(inputname(i)) = varargin{i};
	end
end
