% reads energy and gradients from output file

function tostd()
	global eV
	global bohr

	if exist('./singlepoint.log','file')
		s = fileread('singlepoint.log');
		e = regexp(s,'EUMP2 = +(-?\d+\.\d*)D([+-]\d*)','tokens');
		if isempty(e)
			e = regexp(s,'SCF Done:[^=]+=  (-?\d+\.\d*) ','tokens');
			e = str2double(e{1}{1});
		else	
			e = str2double(e{1}{1})*10^str2double(e{1}{2});
		end
		tok = regexp(s,'Forces \(.*?--+\n(.*?)--','tokens');
		tok = tok{1}{1};
		tok = regexp(tok,'(-?\d+\.\d*)','tokens');
		n = size(tok,2)/3;
		g = zeros(n,3);
		for i=1:n
			for j=1:3
				g(i,j) = -str2double(tok{3*(i-1)+j}{1});
			end
		end
	elseif exist('./gradient','file')
		s = fileread('gradient');
		e = regexp(s,'SCF energy = +(-?\d+\.\d*) ','tokens');
		e = str2double(e{1}{1});
		tok = regexp(s,'([0-].\d+D[-\+]\d+)','tokens');
		n = size(tok,2)/3;
		g = zeros(n,3);
		for i=1:n
			for j=1:3
				g(i,j) = str2num(tok{3*(i-1)+j}{1});
			end
		end
	elseif exist('./OUTCAR','file')
		s=fileread('OUTCAR');
		n=regexp(s,'NIONS = +(\d+)','tokens');
		n=str2num(n{1}{1});
		e=regexp(s,'ENERGIE.+TOTEN += +(-?\d+\.\d*) eV','tokens');
		e=str2double(e{1}{1})/eV;
		g=regexp(s,'TOTAL-FORCE.+ -+\n([ \d\.\n-]+) -+','tokens');
		g=-str2num(g{1}{1})/eV*bohr;
		g(:,1:3)=[];
	else
		error('No output recognized');
	end
	fid=fopen('e','w');
	fprintf(fid,'%.10f',e);
	fclose(fid);
	fid=fopen('g','w');
	fprintf(fid,'%13.10f %13.10f %13.10f\n',g');
	fclose(fid);
end
