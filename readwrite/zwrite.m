% very simply writes all optimized parameters of Z-matrix. 12/04/17

function zwrite(zmat,name)
	fid = fopen(name,'w');
	fprintf(fid,'%10.5f\n',zmat.var);
	fclose(fid);
end


