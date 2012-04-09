% discard not allowed bonds from bond matrix. NOT COMPLETE 12/04/09

function bond = onlyallowed(bond,allowed,atoms,R)
	if isempty(allowed), return, end
	n = size(bond,1);
	allow = false(n);
	for i = 1:length(allowed.types)
		rule = allowed.types{i};
		for j = 1:2
			at{j} = find(atoms==rule{j});
		end
		allow(at{1},at{2}) = true;
		allow(at{2},at{1}) = true;
	end
	for i = 1:length(allowed.elems)
		rule = allowed.elems{i};
		ruled = find(atoms==rule{1});
		for j = 1:length(ruled)
			neigh = find(bond(ruled(j),:));
			distances = R(ruled(j),neigh);
			sorted = sort(distances);
			maxdist = sorted(rule{2});
			allow(ruled(j),neigh(distances<maxdist)) = true;
			allow(neigh(distances<maxdist),ruled(j)) = true;
		end
	end
	for i = 1:length(allowed.atoms)
		% to do
		error('finish onlyallowed');
	end
	bond = allow & bond;
end
