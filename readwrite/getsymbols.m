% author: Ota Bludsky
% modified: JH

function atoms = getsymbols(filename)
	% reads atomic symbols (cell array) from POTCAR
	fid = fopen(filename,'r');
	ns = 0;
	while ~feof(fid)
		l = fgets(fid);
		if isempty(regexp(l,'VRHFIN'))
			continue
		else
			s = regexp(l,'VRHFIN *=(\w+) *:','tokens');
			ns = ns+1;
			atoms{ns} = s{1}{1};
		end
	end
	fclose(fid);
end
