function aprint(s,varargin)
	load workspace.mat fid steps
	fprintf(fid,[num2str(steps) ' ' s],varargin{:});
	ffflush(fid);
end
