% writes cartesian definition of geometry

function writeX(x,atoms,filename)
	n = size(x,1);
	fid = fopen(filename,'w');
	fprintf(fid,'%d\n  created by writeX.m\n',n);
	for i=1:n
		fprintf(fid,'%-2s %10.6f %10.6f %10.6f\n',atoms{i},x(i,:));
	end
	fclose(fid);
end
