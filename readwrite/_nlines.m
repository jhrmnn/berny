function n = nlines(filename)
	n = 0;
	if exist(filename,'file')
		fid = fopen(filename,'r');
		while ~feof(fid);
			l = fgets(fid);
			n = n+1;
		end
		if l(end)==sprintf('\n')
			n = n+1;
		end
	end
end
