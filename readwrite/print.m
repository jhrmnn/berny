% fprintf mod. 12/04/07

function print(s,varargin)
	global param steps
	fid = param.fid;
	if nargin > 1 && strcmp(varargin{end},'gui')
		% if last argument is 'gui', print into standard output
		varargin(end) = [];
		fprintf(1,'%i ',steps)
		fprintf(1,s,varargin{:});
		fprintf(1,'\n');
		octfflush(1);
		if fid == 1, return, end
	end
	if fid > 0
		fseek(fid,0,'eof');
		fprintf(fid,'%i ',steps);
		fprintf(fid,s,varargin{:});
		fprintf(fid,'\n');
		octfflush(fid);
	end
end
