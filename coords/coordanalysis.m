function coordanalysis(ind,m,nfrag)
	global fid
	int(1) = 1;
	int(2) = int(1)+length(find(ind(:,3)==0));
	int(3) = int(2)+length(find(ind(:,4)==0));
	int(4) = size(ind,1)+1;
	k = [1 2 max(ind(int(3):int(4)-1,5))];
	for i=1:3
		for j=1:k(i)+1
			info{i}(j) = length(find(ind(int(i):int(i+1)-1,5)==j-1));
		end
	end
	fprintf(fid,'0 Coordinates information:\n');
	fprintf(fid,'0 * Number of atoms: %g\n',m);
	fprintf(fid,'0 * Number of fragments: %g\n',nfrag);
	fprintf(fid,'0 * Number of internal coordinates: %g\n',size(ind,1));
	fprintf(fid,'0 * Number of strong bonds: %g\n',info{1}(1));
	fprintf(fid,'0 * Number of weak bonds: %g\n',info{1}(2));
	fprintf(fid,'0 * Number of strong angles: %g\n',info{2}(1));
	fprintf(fid,'0 * Number of weak angles: %g\n',info{2}(2));
	fprintf(fid,'0 * Number of superweak angles: %g\n',info{2}(3));
	for i=1:length(info{3})
		fprintf(fid,'0 * Number of dihedrals of weakness %i: %g\n',...
								i-1,info{3}(i));
	end
end
	
	
