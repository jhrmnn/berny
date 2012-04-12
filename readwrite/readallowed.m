% reads file with specification of allowed bonds. 12/04/12

function allowed = readallowed(filename)
	if isempty(filename)
		allowed = [];	return
	end
	fid = fopen(filename,'r');
	allowed = struct('types',[],'elems',[],'atoms',[]);
	itypes = 1;
	ielems = 1;
	while ~feof(fid)
		a = fscanf(fid,'%s',1);
		b = fscanf(fid,'%s',1);
		A = sscanf(a,'%i');
		B = sscanf(b,'%i');
		if isempty(A)
			if isempty(B)
				allowed.types{itypes}{1} = element(a);
				allowed.types{itypes}{2} = element(b);
				itypes = itypes+1;
			else
				allowed.elems{ielems}{1} = element(a);
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
