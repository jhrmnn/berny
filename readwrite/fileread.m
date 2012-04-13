% imitation of Matlab fileread() for Octave. 12/04/13

function s = fileread(filename)
	fid = fopen(filename,'r');
	s = fread(fid,'*char')';
	fclose(fid);
end
