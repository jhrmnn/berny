function ffflush(fid)
	if ~exist('matlabroot','builtin')
		fflush(fid);
	end
end
