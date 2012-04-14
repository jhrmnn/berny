#!/home/hermann/local/bin/oct -q
arg = argv(); % get arguments
if length(arg) < 4 % if not enough, print info
	fprintf(1,[...
		'Usage: OPT <opt file> <queue> <number of cpu> <memory per cpu>\n'...
		'The opt file has to contain at least:\n'...
		'  geometry = <xyz file>\n'...
		'  input = <input file>\n']);
	return
end
[optfile,queue,ncpu,memory] = deal(arg{:}); % name arguments
dir = mfilename('fullpath'); % where are the function files
dir(end-length('OPT')+1:end) = [];
funcs = {'core' 'coords'  'math' 'periodic' 'frontend' 'readwrite'};
p = ''; % path
for i = 1:length(funcs)
	p = [p dir funcs{i} pathsep()];
end
addpath(p); % add berny function files
jobfile = [optfile '.dqs'];
fid = fopen(jobfile,'w');
fprintf(fid,[... % print jobfile
	'#!/home/hermann/local/bin/oct -q\n'... % run in octave
	'addpath(''%s'');\n'... % update path
	'driver(''%s'');\n'... % run main driver
	'delete %s\n'],p,optfile,jobfile); % delete jobfile
fclose(fid);
if exist('qout','dir') % output folder
	system('rm qout/*');
else
	mkdir qout
end
param = setparam(optfile); % just to obtain program
if strncmp(param.program,'vasp',4)
	envir = 'mpi'; % if VASP, run MPI
else
	envir = 'shm'; % otherwise run single host machine
end
command = sprintf(...
	'qsub -V -l mem=%s -cwd -e qout -o qout -pe %s %s -N %s -q %s %s',...
	memory,envir,ncpu,optfile,queue,jobfile); % queueing command
fprintf(1,'Submitting optimization job %s to queue %s\n',jobfile,queue);
fprintf(1,'%s\n',command);
system(command); % RUN!
