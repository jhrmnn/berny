% fprintf mod, prints even into gui. 12/04/07

function alwaysprint(s,varargin)
	load workspace.mat fid steps
	fprintf(fid,[num2str(steps) ' ' s],varargin{:});
	ffflush(fid);
end
