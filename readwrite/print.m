% fprintf mod. 12/04/07

function print(s,varargin)
	global fid steps
	fseek(fid,0,'eof');
	s = ['%i ' s '\n'];
	if nargin > 1 && strcmp(varargin{end},'always')
		% if last argument is 'always', print anyway
		varargin(end) = [];
		fprintf(1,s,steps,varargin{:});
		octfflush(1);
	end
	if fid > 0
		fprintf(fid,s,steps,varargin{:});
		octfflush(fid);
	end
end
