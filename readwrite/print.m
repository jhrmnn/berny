% fprintf mod. 12/04/07

function print(s,varargin)
	global fid steps
	s = ['%i ' s '\n'];
	if nargin > 1 && strcmp(varargin{end},'always')
		% if last argument is 'always', print anyway
		varargin(end) = [];
		fprintf(1,s,steps,varargin{:});
	end
	if fid > 0
		fprintf(fid,s,steps,varargin{:});
		if ~exist('matlabroot','builtin')
			fflush(fid); % force octave to flush buffer
		end
	end
end
