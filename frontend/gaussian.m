% run gaussian to obtain energy. 12/04/14

function energy = gaussian(geom,param)
	global angstrom
	dir = pwd();
	id = getenv('JOB_ID');
	scr = head(id,param.program);
	copyfile(param.input,scr);
	cd(scr);
	writeX(geom,'opt.xyz');
	fprintf(param.fid,'entering Gaussian ...\n');
	octfflush(param.fid);
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
	octfflush(param.fid);
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
			energy.g(i,j) = -str2double(g{3*(i-1)+j}{1})*angstrom;
		end
	end
	cd(dir);
	rmdir(scr,'s');
end

