function xyz2car(filename)
	if ~isempty(filename)
		filename = [filename '.'];
	end
	[xyz,atoms]=readX([filename 'xyz']);
	abc=load([filename 'abc']);
	
	ind=1:length(atoms);
	i=1;
	while sum(ind)
		elem{i}=atoms{ind(find(ind,1))};
		elemind{i}=strmatch(elem{i},atoms,'exact');
		ind(elemind{i})=0;
		i=i+1;
	end
	elemarr=zeros(length(elem),2);
	for i=1:length(elem)
		elemarr(i,1:length(elem{i}))=elem{i};
	end
	if exist('POTCAR','file')
		disp('Order of elements in POSCAR read from POTCAR');
		potcar = getsymbols('POTCAR');
		n = length(potcar);
		transp = zeros(n,1);
		for i=1:n
			for j=1:n
				if strcmp(potcar{i},elem{j})
					transp(i) = j;
				end
			end
		end
	else
		disp('Order of elements in POSCAR is as they come from xyz file')
		transp = 1:length(elem);
	end

	if isempty(filename)
		filename='POSCAR';
	else
		filename(end)=[];
	end
	fid=fopen(filename,'w');	
	elemline='';
	for i=1:length(elem)
		elemline=[elemline elem{transp(i)} ' '];
	end
	elemline=strtrim(elemline);
	fprintf(fid,'%s\n1.0\n',elemline);
	fprintf(fid,'%13.10f %13.10f %13.10f\n',abc');
	fprintf(fid,'%s\n',elemline);
	for i=1:length(elem)
		fprintf(fid,'%i ',length(elemind{transp(i)}));
	end
	fprintf(fid,'\ndirect\n');
	A=inv(abc)';
	for i=1:length(elem)
		for j=1:length(elemind{transp(i)})
			fprintf(fid,'%14.10f',A*xyz(elemind{transp(i)}(j),:)');
			fprintf(fid,'\n');
		end
	end
	fclose(fid);
end
