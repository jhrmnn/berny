% main driver of the berny package. 12/04/13

function driver(optname)
	param = setparam(optname); % set parameters
	logfile = [optname '.log']; % set logfile
	fid = fopen(logfile,'w'); % open logfile
	if strncmp(param.program,'vasp',4)
		geom = car2geom(param.geometry);
		delete('OSZICAR');
	else
		geom = readX(param.geometry);
		geom.periodic = false;
	end
	[stat,node] = system('uname -n'); % where are we?
	fprintf(fid,'Node: %s',node);
	fprintf(fid,'Time: %s\n',datestr(now()));
	geomname = [optname '.xyz']; % geometry history
	if exist(geomname,'file'), delete(geomname); end
	param.fid = fid; % put fid into parameters
	fprintf(fid,'entering initialitation ...\n'); octfflush(1);
	t = time(); % start clock
	geom = initiate(geom,param); % make initialization stuff
	fprintf(fid,'... exiting initialization after %i seconds\n',...
		round(time()-t)); octfflush(1); % stop clock
	for i = 1:param.maxsteps
		writeX(geom,geomname); % write current geometry (after symmetrization)
		energy = getenergy(geom,param); % obtain energy
		t = time(); % start clock
		fprintf(fid,'entering berny ...\n'); octfflush(1);
		[geom,state] = berny(geom,energy); % perform berny
		fprintf(fid,'... exiting berny after %i seconds\n',...
			round(time()-t)); octfflush(1); % stop clock
		if state, break, end
		if i == param.maxsteps
			fprintf(fid,'Maximum number of steps reached\n');
		end
	end
	if state
		fprintf(fid,'Geometry converged in %i steps\n',i);
	end
	fclose(fid);
	delete berny.mat
end

function energy = getenergy(geom,param)
	if strncmp(param.program,'vasp',4)
		energy = vasp(geom,param);
	else
		switch param.program
			case 'gaussian'
				energy = gaussian(geom,param);
		end
	end
end

