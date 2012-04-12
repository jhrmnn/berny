% writes cartesian definition of geometry. 12/04/07

function writeX(geom,filename)
	n = geom.n;
	fid = fopen(filename,'a');
	fprintf(fid,'%d\n\n',n);
	for i = 1:n
		fprintf(fid,'%-2s %10.6f %10.6f %10.6f\n',...
			element(geom.atoms(i)),geom.xyz(i,:));
	end
	fclose(fid);
end
