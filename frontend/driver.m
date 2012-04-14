% main driver of the berny package. 12/04/13

function driver(optname)
	param = setparam(optname); % set parameters
	param.logfile = [optname '.log']; % set logfile
	fid = fopen(param.logfile,'w'); % open logfile
	switch param.program
		case 'vasp' % if VASP, read POSCAR
			geom = car2geom('POSCAR');
		otherwise % otherwise read xyz geometry
			geom = readX(param.geometry);
			geom.periodic = false;
	end
	[stat,node] = system('uname -n'); % where are we?
	fprintf(fid,'Node: %s',node);
	fprintf(fid,'Time: %s\n',datestr(now()));
	geomname = [optname '.xyz']; % geometry history
	if exist(geomname,'file'), delete(geomname); end
	param.fid = fid; % put fid into parameters
	geom = initiate(geom,param); % make initialization stuff
	for i = 1:param.maxsteps
		writeX(geom,geomname); % write current geometry (after symmetrization)
		energy = getenergy(geom,param); % obtain energy
		t = time(); % start clock
		fprintf(fid,'entering berny ...\n'); octfflush(1);
		[geom,state] = berny(geom,energy); % perform berny
		fprintf(fid,'... exiting berny after %i seconds\n',...
			round(time()-t)); octfflush(1); % stop clock
		if state, break, end
	end
	delete berny.mat
end

function energy = getenergy(geom,param)
	switch param.program
		case 'gaussian'
			energy = gaussian(geom,param);
	end
end

