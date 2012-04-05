function allowed = readallowed(filename)
	allowed = struct('types',[],'elems',[],'atoms',[]);
	fid = fopen(filename,'r');
	itypes = 1;
	ielems = 1;
	while ~feof(fid)
		a = fscanf(fid,'%s',1);
		b = fscanf(fid,'%s',1);
		A = str2num(a);
		B = str2num(b);
		if isempty(A)
			if isempty(B)
				allowed.types{itypes}{1} = a;
				allowed.types{itypes}{2} = b;
				itypes = itypes+1;
			else
				allowed.elems{ielems}{1} = a;
				allowed.elems{ielems}{2} = B;
				ielems = ielems+1;
			end
		else
			allowed.atoms{A} = B;
		end
		fgets(fid);
	end
	fclose(fid);
end