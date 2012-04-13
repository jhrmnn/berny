% flushes file stream, only runs in octave. 12/04/13

function octfflush(fid)
	if ~exist('matlabroot','builtin')
		fflush(fid); % force octave to flush buffer
	end
end
