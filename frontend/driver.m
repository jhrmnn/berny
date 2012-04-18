% main driver of the berny package. 12/04/13

function driver(optname)
	param = setparam(optname); % set parameters
	logfile = [optname '.log']; % set logfile
	fid = fopen(logfile,'w'); % open logfile
	if strncmp(param.program,'vasp',4)
		geom = car2geom('POSCAR');
		delete('OSZICAR');
	elseif isfield(param,'geometry')
		geom = readX(param.geometry);
		geom.periodic = false;
	elseif isfield(param,'zmat')
		geom.zmat = zunits(zread(param.zmat),'toau');
		geom.atoms = geom.zmat.def(:,1);
		geom.n = length(geom.atoms);
		geom.xyz = zmat2xyz(geom.zmat);
		geom.periodic = false;
	end
	[void,node] = system('uname -n'); % where are we?
	fprintf(fid,'Node: %s\n',strtrim(node));
	fprintf(fid,'Time: %s\n',datestr(now()));
	geomname = [optname '.xyz']; % geometry history
	if exist(geomname,'file'), delete(geomname); end
	param.fid = fid; % put fid into parameters
	fprintf(fid,'entering initialitation ...\n'); octfflush(fid);
	t = clock(); % start clock
	geom = initiate(geom,param); % make initialization stuff
	fprintf(fid,'... exiting initialization after %.2f seconds\n',...
		etime(clock(),t)); octfflush(fid); % stop clock
	state = false;
	for i = 1:param.maxsteps
		writeX(geom,geomname); % write current geometry (after symmetrization)
		if isfield(param,'zmat')
			zwrite(zunits(geom.zmat,'toangstrom'),[optname '.zmat']);
		end
		energy = getenergy(geom,param); % obtain energy
		save -v6 -append berny.mat energy geom
		t = clock(); % start clock
		fprintf(fid,'entering berny ...\n'); octfflush(fid);
		[geom,state] = berny(); % perform berny
		fprintf(fid,'... exiting berny after %.2f seconds\n',...
			etime(clock(),t)); octfflush(fid); % stop clock
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
	energy.E = 0;
	energy.g = zeros(length(geom.atoms),3);
	if strncmp(param.program,'vasp',4)
		energy = vasp(geom,param);
	else
		switch param.program
			case 'gaussian'
				energy = gaussian2(geom,param);
		end
	end
end

