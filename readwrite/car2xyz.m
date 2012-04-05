function car2xyz(filename,varargin)
	% varargin{1} says which atoms should be translated
	% varargin{2} says the translation vector in fractionals
	fid=fopen(filename,'r');
	fgetl(fid);
	scale=fscanf(fid,'%g',1); fgetl(fid);
	abc=fscanf(fid,'%g',[3 3])'; fgetl(fid);
	abc = scale*abc;
	A=inv(abc)';
	l=fgetl(fid);
	elem = regexp(l,'([A-Za-z]+)','tokens');
	if isempty(elem)
		if exist('POTCAR','file')
			elem = getsymbols('POTCAR');
			disp('Elements read from POTCAR');
		else
			error(['No information about element order. Either supply POTCAR '...
				'or add a line stating elements uner the lattice vectors definition']);
		end
	else
		for i=1:length(elem)
			elem{i}=elem{i}{1};
		end
		disp('Elements read from POSCAR');
		l = fgetl(fid);
	end
	num=sscanf(l,'%i');
	type=fscanf(fid,'%s',1); fgetl(fid); 
	xyz=fscanf(fid,'%g',[3 sum(num)])';
	fclose(fid);

	fid=fopen([filename '.xyz'],'w');
	fprintf(fid,'%i\n',sum(num));
	fprintf(fid,'  %s\n','created by car2xyz');
	if type(1)=='c' || type(1)=='C'
		for i=1:size(xyz,1)
			xyz(i,:) = (A*xyz(i,:)')';
		end
	end
	if length(varargin)==2
		for i=1:length(varargin{1})
			for j=1:3
				xyz(varargin{1}(i),j)=xyz(varargin{1}(i),j)+varargin{2}(j);
			end
		end
	end
	k=1;
	for i=1:length(num)
		for j=1:num(i)
			fprintf(fid,'%-2s %10.6f %10.6f %10.6f\n',elem{i},(abc'*xyz(k,:)')');
			k=k+1;
		end
	end
	fclose(fid);
	
	fid=fopen([filename '.abc'],'w');
	fprintf(fid,'%13.10f %13.10f %13.10f\n',abc');
	fclose(fid);
end
