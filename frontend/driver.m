% main driver of the berny package. 12/04/13

function driver(optname)
	param = setparam(optname);
	param.logfile = [optname '.log'];
	fid = fopen(param.logfile,'w');
	switch param.program
		case 'vasp'
			geom = car2geom('POSCAR');
		otherwise
			geom = readX(param.geometry);
			geom.periodic = false;
	end
	[stat,node] = system('uname -n');
	fprintf(fid,'Node: %s',node);
	fprintf(fid,'Time: %s\n',datestr(now()));
	geomname = [optname '.xyz'];
	param.fid = fid;
	tic;
	fprintf(1,'starting %s ...\n',optname); octfflush(1);
	geom = initiate(geom,param);
	for i = 1:param.maxsteps
		writeX(geom,geomname);
		energy = getenergy(param);
		[geom,state] = berny(geom,energy);
		if state, break, end
	end
	fprintf(1,'... %s finished in %i steps\n',optname,i);
	toc; octfflush(1);
	delete berny.mat
end

function energy = getenergy(geom,param)
	switch param.program
		case 'gaussian'
			energy = gaussian(geom,param);
	end
end

function energy = gaussian(geom,param)
	dir = pwd();
	id = getenv('JOB_ID');
	scr = head(id,param.program);
	writeX(geom,'opt.xyz');
	copyfile('opt.xyz',scr);
	copyfile(param.input,scr);
	cd(scr);
	fprintf(param.fid,'entering Gaussian ...\n');
	octflush(param.fid);
	t = time();
	fidxyz = fopen('opt.xyz');
	fidinput = fopen(param.input,'a');
	n = fscanf(fidxyz,'%d',1);
	fgets(fidxyz); fgets(fidxyz);
	for i = 1:n
		line = fgets(fidxyz);
		fprintf(fidinput,'%s',line);
	end
	fprintf(fidinput,'\n');
	fclose(fidxyz); fclose(fidinput);
	system(sprintf('g09 < %s > g09.log',param.input));
	fprintf(param.fid,...
		'... exiting Gaussian after %i seconds\n',round(time()-t));
	octflush(param.fid);
	s = fileread('g09.log');
	E = regexp(s,'EUMP2 = +(-?\d+\.\d*)D([+-]\d*)','tokens');
	if isempty(E)
		E = regexp(s,'SCF Done:[^=]+=  (-?\d+\.\d*) ','tokens');
		energy.E = str2double(E{1}{1});
	else	
		energy.E = str2double(E{1}{1})*10^str2double(E{1}{2});
	end
	g = regexp(s,'Forces \(.*?--+\n(.*?)--','tokens');
	g = g{1}{1};
	g = regexp(g,'(-?\d+\.\d*)','tokens');
	n = size(g,2)/3;
	energy.g = zeros(n,3);
	for i = 1:n
		for j = 1:3
			energy.g(i,j) = -str2double(g{3*(i-1)+j}{1});
		end
	end
	cd(dir);
	rmdir(scr,'s');
end
