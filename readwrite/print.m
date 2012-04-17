% fprintf mod. 12/04/07

function print(s,varargin)
	global fid steps
	if nargin > 1 && strcmp(varargin{end},'always')
		% if last argument is 'always', print anyway
		varargin(end) = [];
		fprintf(1,'%i ',steps)
		fprintf(1,s,varargin{:});
		fprintf(1,'\n');
		octfflush(1);
	end
	if fid > 0
		fseek(fid,0,'eof');
		fprintf(fid,'%i ',steps)
		fprintf(fid,s,varargin{:});
		fprintf(fid,'\n');
		octfflush(fid);
	end
end
