function opt(jobname)
	logfile=[jobname '.log'];
	system(['echo "Node:" `uname -n` >> ' logfile]);
	fid=fopen(logfile,'a');
	fprintf(fid,'Time: %s\n',datestr(now));
	scriptdir=regexp(mfilename('fullpath'),'(.+)/opt','tokens');
	scriptdir=scriptdir{1}{1};
	[void,branch]=system(['cd ' scriptdir '; /home/hermann/local/bin/git branch']);
	branch=regexp(branch,'\* (.+)\n$','tokens');
	branch=branch{1}{1};
	[void,version]=system(['cd ' scriptdir '; /home/hermann/local/bin/git show -s --oneline HEAD']);
	version=regexp(version,'^(\w+) ','tokens');
	version=version{1}{1};
	fprintf(fid,['Using ' branch ' branch, version ' version '.\n']);
	try
		global eV bohr
		eV = 27.211396132; 
		bohr = 0.52917720859;
		param = setparam(jobname);
		switch param.restart
			case 'energy'
				fprintf(fid,['>>> Restarting the optimization. '...
				             'Continuing by computing the energy\n']);
			case 'berny'
				fprintf(fid,['>>> Restarting the optimization. '...
				             'Continuing by calling the berny routine\n']);
			otherwise
				delete('workspace.mat');
		end
		dir=pwd();
		id=getenv('JOB_ID');
		[scr,run]=head(id,param.program);
		if strncmp(param.program,'vasp',4)
			program='vasp';
		else
			program=param.program;
		end
		switch program
			case 'turbomole'
				prgname='Turbomole';
			case 'gaussian'
				prgname='Gaussian';
			case 'vasp'
				prgname='VASP';
		end
		if strcmp(program,'vasp')
			if strcmp(param.restart,'no')
				car2xyz(param.geometry);
				movefile([param.geometry '.xyz'],'xyz');
				movefile([param.geometry '.abc'],'abc');
			end
			nelm = readnelm(param.input);
		else
			if exist('strains','file')
				copyfile('strains',scr)
			end
			copyfile(param.geometry,[scr '/xyz']);
			copyfile(param.input,scr);
		end
		fprintf(fid,'Maximum number of steps: %d\n',param.maxsteps);
		if ~strcmp(program,'vasp')
			cd(scr);
		end
		if strcmp(program,'turbomole')
			system('x2t xyz > coord');
			system(['define < ' param.input ' >> /dev/null 2> define.log']);
			[stat,grep]=system('grep "ended abnormally" define.log');
			if ~isempty(grep)
				error('define ended abnormally');
			end
		end
		i=0;
		while true
			if ~strcmp(param.restart,'energy')
				if i>=param.maxsteps && strcmp(param.stop,'energy')
					error('Maximum number of steps reached: the geometry is not optimized!');
				end
				fclose(fid);
				fid=fopen(logfile,'a');
				fprintf(fid,'Entering Octave calculation: %d\n',i); ffflush(fid);
				t = time();
				try
					isconverged = berny(fid,param);
				catch
					err = lasterror();
					fprintf(fid,'%s\n%s\nline: %i, column: %i\n',err.message,err.stack.file,err.stack.line,err.stack.column);
					error('berny ended with error');
				end
				fprintf(fid,'Octave ended normally after %f seconds\n',time()-t);
				ffflush(fid);
				if isconverged
					if ~strcmp(program,'vasp')
						copyfile('xyz',[dir '/' param.geometry '.optimized']);
					else
						copyfile('POSCAR','POSCAR.optimized')
					end
					delete('e');
					delete('g');
					delete('xyz');
					delete('abc');
					delete('workspace.mat');
					break
				else
					system('cat xyz >> geomhistory');
				end
				if i>=param.maxsteps
					error('Maximum number of steps reached: the geometry is not optimized!');
				end
				i=i+1;
			else
				i=1;
			end
			param.restart = 'no';
			fprintf(fid,['Entering ' prgname ' calculation: %d\n'],i);
			t = time();
			ffflush(fid);
			switch program
				case 'turbomole'
					system('x2t xyz > coord');
					system('ridft > ridft.out 2> tbm.log');
					system('rdgrad > rdgrad.out 2> tbm.log');
					[stat,grep]=system('grep "ended abnormally" tbm.log');
					if ~isempty(grep)
						error('Turbomole ended abnormally');
					end
				case 'gaussian'
					fidxyz=fopen('xyz');
					copyfile(param.input,'singlepoint');
					fidinput=fopen('singlepoint','a');
					n=fscanf(fidxyz,'%d',1);
					fgetl(fidxyz); fgetl(fidxyz);
					for j=1:n
						line=fgetl(fidxyz);
						fprintf(fidinput,'%s\n',line);
					end
					fprintf(fidinput,'\n');
					fclose(fidxyz); fclose(fidinput);
					system('g09 < singlepoint > singlepoint.log');
					[stat,grep]=system('grep "Normal termination" singlepoint.log');
					if isempty(grep)
						error('Gaussian ended abnormally');
					end
				case 'vasp'
					xyz2car('');
					system(run);
					if nlines('OSZICAR')-3 == nelm
						delete('WAVECAR');
						delete('CHGCAR');
						system('cat OSZICAR >> OSZIhistory');
						fprintf(fid,'!!! VASP did not converge, starting again without WAVECAR and CHGCAR\n');
						ffflush(fid);
						system(run);
						if nlines('OSZICAR')-3 == nelm
							system('cat OSZICAR >> OSZIhistory');
							error('VASP did not converge at all. Solve it.');
						end
					end
					system('cat OSZICAR >> OSZIhistory');
			end
			fprintf(fid,[prgname ' terminated normally after %f seconds\n'],...
							time()-t);
			ffflush(fid);
			try
				tostd();
			catch
				err = lasterror();
				fprintf(fid,'%s\n%s\nline: %i, column: %i\n',err.message,err.stack.file,err.stack.line,err.stack.column);
				error('I cannot read the energy or gradient');
			end
			if strcmp(program,'turbomole')
				delete('gradient');
			end
		end
	catch
		err = lasterror();
		fprintf(fid,'%s\n%s\nline: %i, column: %i\n',err.message,err.stack.file,err.stack.line,err.stack.column);
	end
	ffflush(fid);
	fclose(fid);
	if exist('scr','var')
		cd(dir);
		rmdir(scr,'s');
	end
end

function nelm = readnelm(filename)
	if exist(filename,'file')
		fid = fopen(filename,'r');
		while ~feof(fid)
			l = fgets(fid);
			if l(1)=='!'
				continue
			end
			nelm = regexp(l,'NELM *= *(\d+)','tokens');
			if ~isempty(nelm)
				nelm = str2double(nelm{1}{1});
				return
			end
		end
	end
	nelm = 60;
end
