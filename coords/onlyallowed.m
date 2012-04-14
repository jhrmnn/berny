% discard not allowed bonds from bond matrix. NOT COMPLETE 12/04/09

function bond = onlyallowed(bond,allowed,atoms,R)
	if isempty(allowed), return, end
	n = size(bond,1);
	allow = false(n);
	for i = 1:size(allowed.types,1)
		rule = allowed.types(i,:);
		at1 = find(atoms==rule(1));
		at2 = find(atoms==rule(2));
		allow(at1,at2) = true;
		allow(at2,at1) = true;
	end
	for i = 1:size(allowed.elems,1)
		rule = allowed.elems(i,:);
		ruled = find(atoms==rule(1));
		for j = 1:length(ruled)
			neigh = find(bond(ruled(j),:));
			distances = R(ruled(j),neigh);
			sorted = sort(distances);
			maxdist = sorted(rule(2));
			allow(ruled(j),neigh(distances<maxdist)) = true;
			allow(neigh(distances<maxdist),ruled(j)) = true;
		end
	end
	for i = 1:size(allowed.atoms,1)
		% to do
		error('finish onlyallowed');
	end
	bond = allow & bond;
end
