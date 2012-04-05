function str = fileread(filename)
	fid=fopen(filename,'r');
	str=fread(fid,'*char')';
	fclose(fid);
end
