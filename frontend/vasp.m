% run VASP to obtain energy. 12/04/14

function energy = vasp(geom,param)
	fid = param.fid;
	id = getenv('JOB_ID'); % get job ID
	[scr,run] = head(id,param.program); % set PATH, make scratch
	geom2car(geom,'POSCAR'); % write geometry to POSCAR
	nelm = readnelm();
	fprintf(fid,'entering VASP ...\n'); octfflush(fid);
	t = time(); % start clock
	system(run); % run VASP
	if nlines('OSZICAR')-3 == nelm
		delete('WAVECAR');
		delete('CHGCAR');
		system('cat OSZICAR >> OSZICAR.opt');
		fprintf(fid,['! VASP did not converge, starting again '...
			'without WAVECAR and CHGCAR\n']); octfflush(fid);
		system(run);
		if nlines('OSZICAR')-3 == nelm
			system('cat OSZICAR >> OSZICAR.opt');
			error('!! VASP did not converge even after restart, terminating');
		end
	end
	system('cat OSZICAR >> OSZICAR.opt');
	fprintf(fid,'... exiting VASP after %i seconds\n',...
		round(time()-t)); octfflush(fid); % stop clock
	rmdir(scr,'s'); % delete scratch
	s = fileread('OUTCAR');
	e = regexp(s,'ENERGIE.+TOTEN += +(-?\d+\.\d*) eV','tokens');
	energy.E = str2double(e{1}{1});
	g = regexp(s,'TOTAL-FORCE.+ -+\n([ \d\.\n-]+) -+','tokens');
	energy.g = -str2num(g{1}{1});
	energy.g(:,1:3) = [];
end

function nelm = readnelm()
	nelm = 60;
	fid = fopen('INCAR','r');
	while ~feof(fid)
		l = fgets(fid);
		if l(1) == '!', continue, end
		snelm = regexp(l,'NELM *= *(\d+)','tokens');
		if ~isempty(snelm)
			nelm = str2double(snelm{1}{1});
			return
		end
	end
end
