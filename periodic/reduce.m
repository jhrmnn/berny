function indnew = reduce(ind,m)
	ii = 1;
	indnew = 0*ind;
	for i=1:size(ind,1)
		coord = ind(i,1:4);
		coord = coord(coord>0);
		k = length(coord);
		subcell = zeros(k,3); % these will hold info about subcell of the atoms
		for j=1:k
			subcell(j,:) = atom2jkl(coord(j),m);
		end
		if sum(min(subcell))==0 % if it cannot be replicated closer to (0,0,0)
			indnew(ii,:) = ind(i,:); % use it
			ii = ii+1;
		end
	end
	indnew(find(indnew(:,1)==0,1):end,:) = [];
end
