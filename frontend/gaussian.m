% run Gaussian to obtain energy. 12/04/14

function energy = gaussian(geom,param)
	global angstrom
	fid = param.fid;
	dir = pwd(); % where are we?
	id = getenv('JOB_ID'); % get job ID
	scr = head(id,param.program); % set PATH, make scratch
	copyfile(param.input,scr); % copy input to scratch
	cd(scr); % go to scratch
	writeX(geom,'opt.xyz'); % write geometry to xyz
	fprintf(fid,'entering Gaussian ...\n'); octfflush(fid);
	t = clock(); % start clock
	fidxyz = fopen('opt.xyz','r'); % open xyz geometry
	fidinput = fopen(param.input,'a'); % open input file
	n = fscanf(fidxyz,'%d',1); % number of atoms
	fgets(fidxyz); fgets(fidxyz);
	for i = 1:n
		line = fgets(fidxyz); % get line from xyz
		fprintf(fidinput,'%s',line); % put it into input
	end
	fprintf(fidinput,'\n'); % blank line for Gaussian
	fclose(fidxyz); fclose(fidinput);
	system(sprintf('g09 < %s > g09.log',param.input)); % run Gaussian
	fprintf(fid,'... exiting Gaussian after %.2f seconds\n',...
		etime(clock(),t)); octfflush(fid); % stop clock
	s = fileread('g09.log'); % read Gaussian output
	cd(dir); % go back to starting directory
	rmdir(scr,'s'); % delete scratch
	E = regexp(s,'EUMP2 = +(-?\d+\.\d*)D([+-]\d*)','tokens'); % MP2
	if isempty(E) % if not MP2 calculation
		E = regexp(s,'SCF Done:[^=]+=  (-?\d+\.\d*) ','tokens');
		energy.E = str2double(E{1}{1}); % get energy
	else	
		energy.E = str2double(E{1}{1})*10^str2double(E{1}{2});
	end
	g = regexp(s,'Forces \(.*?--+\n(.*?)--','tokens'); % gradient (a.u.)
	g = g{1}{1};
	g = regexp(g,'(-?\d+\.\d*)','tokens'); % extract
	n = size(g,2)/3;
	energy.g = zeros(n,3);
	for i = 1:n
		for j = 1:3
			energy.g(i,j) = -str2double(g{3*(i-1)+j}{1})*angstrom;
		end
	end
end

