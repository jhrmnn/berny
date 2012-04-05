function [scr,run] = head(id,program)
	cluster=whichcluster();
	[stat,user]=system('echo $USER');
	scr=['/scratch/' user(1:end-1) '/' id];
	mkdir(scr);
	m10=[regexp(grep('m10root=','M10_SP'),' (/\S+)\)','tokens'){1}{1} '/bin'];
	g09=[regexp(grep('g09root=','G09'),' (/\S+)\)','tokens'){1}{1} '/g09'];
	if strncmp(program,'vasp2',5)
		program(1:5)=[];
		vasp=[regexp(grep('VASPDIR=','VASP-5.2.12'),'VASPDIR=(\S+)','tokens'){1}{1} '-mp' program];
	elseif strncmp(program,'vasp',4)
		program(1:4)=[];
		vasp=[regexp(grep('VASPDIR=','VASP'),'VASPDIR=(\S+)','tokens'){1}{1} '-mp' program];
	else
		vasp=[regexp(grep('VASPDIR=','VASP'),'VASPDIR=(\S+)','tokens'){1}{1} '-mp'];
	end
	mpi=regexp(grep('MPIRUNS=','VASP'),'MPIRUNS=(\S+)','tokens'){1}{1};
	% tbm='/usr/local/programs/TurboMole/TurboMole5.9/arch/all';
	% [stat,arch]=system([tbm '/scripts/sysname']);
	% putenv('TURBODIR',tbm);
	putenv('MOLPRO_OPTIONS',['--nobackup --no-xml-output -d ' scr ' -W ' scr ' -I ' scr ' -m8M']);
	putenv('GAUSS_SCRDIR',scr);
	putenv('GAUSS_EXEDIR',g09);
	putenv('LD_LIBRARY_PATH',[getenv('LD_LIBRARY_PATH') ':' g09]);
	putenv('PATH',[getenv('PATH') ':' vasp ':' mpi ':' g09 ':' m10]);
	% ':' tbm '/bin/' deblank(arch) ':' tbm '/scripts'
	putenv('OMP_NUM_THREADS','1');
	run=[mpi ' ' vasp '/vasp'];
end

function s = grep(pattern,script)
	[stat,s] = system(['grep ' pattern ' $(which ' script ')']);
end
