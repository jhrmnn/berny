function xyz = symmetrize(geom,symm)
	xyz = geom.xyz/geom.abc; % transform into fractionals
	n = size(xyz,1); % number of atoms
	thre = 0.05./sqrt(sum(geom.abc.^2,2))'; % symmetry detection
	issymmed = false(n,1); % says which atoms were already symmed
	for i = 1:n
		if issymmed(i), continue, end % if already symmed, break
		symmed = makesymages(xyz(i,:),symm);
		[pairing,shift] = pairsymages(xyz,symmed,thre,i);
		equiv = transform1(xyz(pairing,:),symm,shift);
		average = mean(equiv,1);
		[atoms,ind] = unique(pairing);
		xyz(atoms,:) = transformback(average,symm(ind),shift(ind,:));
		issymmed(atoms) = true;
	end
	xyz = xyz*geom.abc; % transforms back to cartesian
	diff = sqrt(sum((geom.xyz-xyz).^2,2));
	print('Symmetrization change. Max: %g, RMS: %g\n',...
					max(diff),rms(diff));
end

function symmed = makesymages(xyz,symm)
	m = length(symm);
	symmed = zeros(m,3);
	for j = 1:m
		symmed(j,:) = xyz*symm{j}(:,1:3)'+symm{j}(:,4)';
	end
end

function [pairing,shift] = pairsymages(xyz,symmed,thre,i)
	m = size(symmed,1);
	n = size(xyz,1);
	pairing = zeros(m,1); % i-th symage is atom pairing(i)
	shift = zeros(m,3); % shift of real atom from symage
	for j = 1:m
		delta = symmed(j*ones(1,n),:)-xyz;
		match = abs(delta-round(delta)) < thre(ones(1,n),:);
		symage = find(all(match,2));
		if isscalar(symage)
			pairing(j) = symage;
			shift(j,:) = round(delta(symage,:));
		else
			error(['%i atoms correspond to %i-th symmetry image '...
				'of atom #%i'],length(symage),j,i);
		end
	end
end

function equiv = transform1(xyz,symm,shift)
	m = length(symm);
	equiv = zeros(m,3);
	for j = 1:m
		equiv(j,:) = ...
			(xyz(j,:)+shift(j,:)-symm{j}(:,4)')/symm{j}(:,1:3)';
	end
end

function xyz = transformback(average,symm,shift)
	n = length(symm);
	xyz = zeros(n,3);
	for j = 1:n
		xyz(j,:) = average*symm{j}(:,1:3)'+symm{j}(:,4)'-shift(j,:);
	end
end
