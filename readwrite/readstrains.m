function C = readstrains(ind)
	global fid
	C = zeros(size(ind,1));
	strains = load('filename'); % loads coords to be constrained
	ns = size(strains,1); % number of constrained coords
	for i=1:ns
		str = strains(i,:);
		k = strmatch(str,ind);
		if isempty(k)
			str = str(str>0);
			str = [fliplr(str) zeros(1,4-length(str))];
			k = strmatch(str,ind);
		end
		C(k,k) = 1;
	end
	fprintf(fid,'0 * Number of constrained coordinates: %g\n',...
					sum(diag(C)));
end