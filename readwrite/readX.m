% reads cartesian definition of geometry. 12/04/13

function geom = readX(filename)
	fid = fopen(filename,'r');
	n = fscanf(fid,'%d',1);
	fgets(fid);
	fgets(fid);
	geom.xyz = zeros(n,3);
	geom.atoms = zeros(n,1);
	for i = 1:n
		geom.atoms(i) = element(fscanf(fid,'%s',1));
		geom.xyz(i,:) = fscanf(fid,'%g',3)';
	end
	fclose(fid);
end
