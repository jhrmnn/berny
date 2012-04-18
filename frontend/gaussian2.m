% run Gaussian to obtain energy. 12/04/14

function energy = gaussian2(geom,param)
	fid = param.fid;
	dir = scriptdir(); % script directory
	inputfile = prepareinput(geom,param.input);
	t = clock(); % start clock
	fprintf(fid,'entering Gaussian ...\n'); octfflush(fid);
	system(sprintf('%sG09 %s',dir,inputfile)); % run Gaussian
	fprintf(fid,'exiting Gaussian after %.2f seconds\n',...
		etime(clock(),t)); octfflush(fid); % stop clock
	delete(inputfile); % delete temporary input
	energy = readoutput([inputfile '.log']);
end

function dir = scriptdir()
	dir = mfilename('fullpath'); % frontend/ directory
	dir = dir(1:end-length(mfilename()));
end

function inputfile = prepareinput(geom,input)
	geomfile = 'opt_temp.xyz';
	inputfile = 'opt_temp.g09';
	writeX(geom,geomfile); % write geometry to xyz
	copyfile(input,inputfile);
	fidxyz = fopen(geomfile,'r'); % open xyz geometry
	fidinput = fopen(inputfile,'a'); % open input file
	n = fscanf(fidxyz,'%d',1); % number of atoms
	fgets(fidxyz); fgets(fidxyz);
	for i = 1:n
		line = fgets(fidxyz); % get line from xyz
		fprintf(fidinput,'%s',line); % put it into input
	end
	fprintf(fidinput,'\n'); % blank line for Gaussian
	fclose(fidxyz); fclose(fidinput);
	delete(geomfile);
end

function energy = readoutput(outputfile)
	global angstrom
	s = fileread(outputfile); % read Gaussian output
	delete(outputfile);
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
