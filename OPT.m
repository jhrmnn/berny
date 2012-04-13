#!/home/hermann/local/bin/oct -q
arg = argv();
if length(arg) < 4
	fprintf(1,[...
		'Usage: OPT <opt file> <queue> <number of cpu> <memory per cpu>\n'...
		'The opt file has to contain at least:\n'...
		'  geometry = <xyz file>\n'...
		'  input = <input file>\n']);
	return
end
[optfile,queue,ncpu,memory] = deal(arg{:});
dir = mfilename('fullpath');
dir(end-length('frontend/OPT')+1:end) = [];
funcs = {'core' 'coords'  'math' 'periodic' 'frontend' 'readwrite'};
p = '';
for i = 1:length(funcs)
	p = [p dir funcs{i} pathsep()];
end
addpath(p);
jobfile = [optfile '.dqs'];
fid = fopen(jobfile,'w');
fprintf(fid,[...
	'#!/home/hermann/local/bin/oct -q\n'...
	'addpath(''%s'');\n'...
	'driver(''%s'');\n'...
	'delete %s\n'],p,optfile,jobfile);
fclose(fid);
param = setparam(optfile);
if exist('qout','dir')
	delete qout/*
else
	mkdir qout
end
if strncmp(param.program,'vasp',4)
	envir = 'mpi';
else
	envir = 'shm';
end
command = sprintf(...
	'qsub -V -l mem=%s -cwd -e qout -o qout -pe %s %s -N %s -q %s %s',...
	memory,envir,ncpu,optfile,queue,jobfile);
fprintf(1,'Submitting optimization job %s to queue %s\n',jobfile,queue);
fprintf(1,'%s\n',command);
system(command);
