% reads file with specification of allowed bonds. 12/04/12

function allowed = readallowed(filename)
	if isempty(filename)
		allowed = [];	return
	end
	fid = fopen(filename,'r');
	allowed = struct('types',[],'elems',[],'atoms',[]);
	itypes = 0;
	ielems = 0;
	iatoms = 0;
	while ~feof(fid)
		a = fscanf(fid,'%s',1);
		b = fscanf(fid,'%s',1);
		A = sscanf(a,'%i');
		B = sscanf(b,'%i');
		if isempty(A)
			if isempty(B)
				itypes = itypes+1;
				allowed.types(itypes,1) = element(a);
				allowed.types(itypes,2) = element(b);
			else
				ielems = ielems+1;
				allowed.elems(ielems,1) = element(a);
				allowed.elems(ielems,2) = B;
			end
		else
			iatoms = iatoms+1;
			allowed.atoms(iatoms,1) = A;
			allowed.atoms(iatoms,2) = B;
		end
		fgets(fid);
	end
	fclose(fid);
end
