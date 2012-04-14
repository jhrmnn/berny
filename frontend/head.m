% creates sratch file and sets environemt. 12/04/13

function [scr,run] = head(id,program)
	[stat,user] = system('echo $USER');
	scr = sprintf('/scratch/%s/%s',user(1:end-1),id);
	mkdir(scr);
	sep = pathsep();
	mpi = regexp(grep('MPIRUNS=','VASP'),'MPIRUNS=(\S+)','tokens');
	mpi = mpi{1}{1};
	switch program
		case 'gaussian'
			g09 = regexp(grep('g09root=','G09'),' (/\S+)\)','tokens');
			g09 = [g09{1}{1} '/g09'];
			putenv('GAUSS_SCRDIR',scr);
			putenv('GAUSS_EXEDIR',g09);
			putenv('LD_LIBRARY_PATH',[getenv('LD_LIBRARY_PATH') ':' g09]);
			putenv('PATH',[getenv('PATH') sep g09]);
		case {'vasp' 'vasp-gamma' 'vasp-vtst' 'vasp-gamma-vtst'}
			program(1:4) = [];
			vasp = regexp(grep('VASPDIR=','VASP'),'VASPDIR=(\S+)','tokens');
			vasp = [vasp{1}{1} '-mp' program];
			putenv('PATH',[getenv('PATH') sep vasp sep mpi]);
			run = [mpi ' ' vasp '/vasp'];
	end
end

function s = grep(pattern,script)
	[stat,s] = system(['grep ' pattern ' $(which ' script ')']);
end
