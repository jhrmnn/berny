function print(s,varargin)
	load workspace.mat fid steps
	if fid > 1
		fprintf(fid,[num2str(steps) ' ' s],varargin{:});
		ffflush(fid);
	end
end
