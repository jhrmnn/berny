% reads cartesian definition of geometry

function [x,atoms] = readX(filename)
	fid=fopen(filename,'r');
	n=fscanf(fid,'%d',1);
	fgetl(fid);
	fgetl(fid);
	x=zeros(n,3);
	atoms=cell(n,1);
	for i=1:n
		atoms{i}=fscanf(fid,'%s',1);
		x(i,:)=fscanf(fid,'%g',3)';
	end
	fclose(fid);
end
