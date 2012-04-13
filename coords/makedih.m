% recursive function which makes dihedrals and potentially 
% deals with linear angles by extending the centre of the 
% dihedral and calling itself. 12/04/10

function [dihs,idih] = makedih(dihs,idih,c,bond,xyz,C)
	neigh1 = find(bond(:,c(1)));
	neigh2 = find(bond(:,c(end)));
	neigh1 = neigh1(neigh1~=c(2));
	neigh2 = neigh2(neigh2~=c(end-1));
	n1 = length(neigh1);
	n2 = length(neigh2);
	ang1 = zeros(n1,1);
	ang2 = zeros(n2,1);
	for j = 1:n1
		ang1(j) = ang(xyz([neigh1(j) c(1:2)],:));
	end
	for j = 1:n2
		ang2(j) = ang(xyz([c(end-1:end) neigh2(j)],:));
	end
	lin1 = ang1>pi-1e-3;
	lin2 = ang2>pi-1e-3;
	islin1 = false;
	islin2 = false;
	ind1 = 1:n1;
	ind2 = 1:n2;
	if any(lin1)
		if sum(lin1) > 1, error('This si weird'); end
		lin1 = find(lin1,1);
		islin1 = true;
		ind1(lin1) = [];
	end
	if any(lin2)
		if sum(lin2) > 1, error('This is weird'); end
		lin2 = find(lin2,1);
		islin2 = true;
		ind2(lin2) = [];
	end
	if c(1) < c(end)
		nweak = 0;
		for j = 1:length(c)-1
			if ~C(c(j),c(j+1))
				nweak = nweak+1;
			end
		end
		for j1 = ind1
			for j2 = ind2
				if neigh1(j1) == neigh2(j2), continue, end
					idih = idih+1;
					if mod(idih,1000) == 1
						dihs = [dihs; zeros(1000,5)];
					end
					dihs(idih,:) = [neigh1(j1) c(1) c(end) neigh2(j2)...
						nweak+~C(neigh1(j1),c(1))+~C(c(end),neigh2(j2))];
			end
		end
	end
	if length(c) >= 4, return, end
	if islin1 && ~islin2
		c = [neigh1(lin1) c];
		[dihs,idih] = makedih(dihs,idih,c,bond,xyz,C);
	end
	if islin2 && ~islin1
		c = [c neigh2(lin2)];
		[dihs,idih] = makedih(dihs,idih,c,bond,xyz,C);
	end
end

function Phi = ang(xyz)
	v1 = xyz(1,:)-xyz(2,:);
	v2 = xyz(3,:)-xyz(2,:);
	Phi = real(acos(v1*v2'/(norm(v1)*norm(v2))));
end
