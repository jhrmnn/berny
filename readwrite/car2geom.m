% generates geom struct from POSCAR with element specification.
% 12/04/07

function geom = car2geom(filename)
	fid = fopen(filename,'r');
	fgets(fid);
	scale = fscanf(fid,'%g',1);
	fgets(fid);
	abc = fscanf(fid,'%g',[3 3])';
	fgets(fid);
	abc = scale*abc;
	l = fgets(fid);
	elem = regexp(l,'([A-Za-z]+)','tokens');
	elem = [elem{:}];
	l = fgets(fid);
	num = sscanf(l,'%i');
	type = fscanf(fid,'%s',1);
	fgets(fid);
	xyz = fscanf(fid,'%g',[3 sum(num)])';
	n = size(xyz,1);
	fclose(fid);
	
	if lower(type(1)) == 'd'
		xyz = xyz*abc; % transform to cartesians
	end
	atoms = zeros(n,1);
	k = 1;
	for i = 1:length(elem)
		Z = element(elem{i});
		atoms(k:k+num(i)-1) = Z(ones(num(i),1));
		k = k+num(i);
	end
	
	geom.n = n;
	geom.atoms = atoms;
	geom.xyz = xyz;
	geom.abc = abc;
	geom.periodic = true;
end
