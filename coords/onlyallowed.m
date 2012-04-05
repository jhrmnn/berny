% discard not allowed bonds from bond matrix

function bond = onlyallowed(bond,allowed,atoms,m,R)
	n = size(bond,1);
	if ~isempty(allowed.types)
		for i=1:n
			for j=1:n
				if bond(i,j)
					isallw = false;
					for k=1:size(allowed.types,2)
						if (strcmp(allowed.types{k}{1},atoms{i}) &&...
						   strcmp(allowed.types{k}{2},atoms{j})) ||...
							 (strcmp(allowed.types{k}{1},atoms{j}) &&...
						   strcmp(allowed.types{k}{2},atoms{i}))
							isallw = true;
						end
					end
					if ~isallw
						bond(i,j) = 0;
					end
				end
			end
		end
	end
	if ~isempty(allowed.elems) || ~isempty(allowed.atoms)
		for i=1:m
			b = R(i:m:n,:);
			a = sort(b(logical(bond(i:m:n,:))));
			j = 2;
			while j<=length(a)
				if abs(a(j)-a(j-1)<1e-10)
					a(j) = [];
				else
					j = j+1;
				end
			end
			max = 0;
			for j=1:size(allowed.elems,2)
				if strcmp(allowed.elems{j}{1},atoms{i})
					max = allowed.elems{j}{2};
				end
			end
			if i<=length(allowed.atoms) && ~isempty(allowed.atoms{i})
				max = allowed.atoms{i};
			end
			if max < length(a) && max > 0
				bond(i:m:n,:) = bond(i:m:n,:).*double(b<a(max)+1e-10);
			end
		end
	end
	bond = bond.*bond';
end