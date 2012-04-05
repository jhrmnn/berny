% generates the list of coordinates
function ind = generatecoords(bond,C,xyz)
	bonds = zeros(length(find(bond))/2,5); % this gives list of all bonds
	[bonds(:,1),bonds(:,2)] = ind2sub(size(bond),find(triu(bond)));
	bonds(:,5) = ~C(find(triu(bond)));
	n = size(bond,1);
	angles = [];
	for i=1:n % cycle through atoms
		neigh = find(bond(:,i)); % neighbours of the atom
		nn = length(neigh);
		for j=1:nn % cycle through unique pairs of neighbours
			for k=j+1:nn
				if ang(xyz([neigh(j) i neigh(k)],:)) > pi/4
					angles = [angles; neigh(j) i neigh(k) 0 ...
					                          2-C(neigh(j),i)-C(neigh(k),i)];
				end
			end
		end
	end
	dihedrals = zeros(1000,5);
	idih = 1;
	for i=1:size(bonds,1) % cycle through bonds
		for j=1:2
			edge = bonds(i,[j 3-j]); % the inital edge, also reversed must be tried
			[dihedrals,idih] = dihedralmaker(... % and here comes the beast
			            idih,edge,bond,xyz,C,dihedrals,~C(bonds(i,1),bonds(i,2)));
		end
	end
	ind = [bonds; angles; dihedrals(1:find(dihedrals(:,1)==0,1)-1,:)];
end
