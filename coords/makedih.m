% recursive function which makes dihedrals and potentially 
% deals with linear angles by extending the centre of the 
% dihedral and calling itself. 12/04/10

function [dihs,idih] = makedih(dihs,idih,c,bond,xyz,C)
	neigh1 = find(bond(:,c(1))); % find neighbors of centre
	neigh2 = find(bond(:,c(end)));
	neigh1 = neigh1(neigh1~=c(2)); % erase obviuos neighbors
	neigh2 = neigh2(neigh2~=c(end-1));
	n1 = length(neigh1); % number of neighbors
	n2 = length(neigh2);
	ang1 = zeros(n1,1); % centre-neighbor angles
	ang2 = zeros(n2,1);
	for j = 1:n1
		ang1(j) = ang(xyz([neigh1(j) c(1:2)],:));
	end
	for j = 1:n2
		ang2(j) = ang(xyz([c(end-1:end) neigh2(j)],:));
	end
	lin1 = ang1>pi-1e-3; % is linear
	lin2 = ang2>pi-1e-3;
	islin1 = false; % is there a linear
	islin2 = false;
	ind1 = 1:n1; % non-linear neighbor indexing
	ind2 = 1:n2;
	if any(lin1) % if linaer
		if sum(lin1) > 1, error('This si weird'); end
		lin1 = find(lin1,1); % find linear
		islin1 = true; % there is a linear
		ind1(lin1) = []; % erase a linaer
	end
	if any(lin2)
		if sum(lin2) > 1, error('This is weird'); end
		lin2 = find(lin2,1);
		islin2 = true;
		ind2(lin2) = [];
	end
	if c(1) < c(end) % add only ascending centres
		nweak = 0; % number of weak bonds in dihedral
		for j = 1:length(c)-1
			if ~C(c(j),c(j+1))
				nweak = nweak+1;
			end
		end
		for j1 = ind1
			for j2 = ind2
				if neigh1(j1) == neigh2(j2), continue, end
				                  % if left neighbor is right neighbor
					idih = idih+1;
					if mod(idih,1000) == 1
						dihs = [dihs; zeros(1000,5)]; % enlarge array
					end
					dihs(idih,:) = [neigh1(j1) c(1) c(end) neigh2(j2)...
						nweak+~C(neigh1(j1),c(1))+~C(c(end),neigh2(j2))];
			end
		end
	end
	if length(c) >= 4, return, end % centre no longer than 4
	if islin1 && ~islin2 % if linear only left
		c = [neigh1(lin1) c];
		[dihs,idih] = makedih(dihs,idih,c,bond,xyz,C);
	elseif islin2 && ~islin1 % if linear only right
		c = [c neigh2(lin2)];
		[dihs,idih] = makedih(dihs,idih,c,bond,xyz,C);
	end
end

function Phi = ang(xyz)
	v1 = xyz(1,:)-xyz(2,:);
	v2 = xyz(3,:)-xyz(2,:);
	Phi = real(acos(v1*v2'/(norm(v1)*norm(v2))));
end
