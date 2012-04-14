% generates system of internal coordinates based on standard 
% covalent radii. 12/04/07

function [coords,rho] = gencoords(geom,allowed)
	if geom.periodic		
		celldim = [-1 1; -1 1; -1 1];
		[xyz,atoms] = ...
			copycell(geom.xyz,geom.abc,celldim,geom.atoms);
	else
		xyz = geom.xyz;
		atoms = geom.atoms;
	end
	R = dist(xyz); % matrix of interatomic distances
	[bond,C,frags,cov] = covalentbond(R,atoms,allowed);
	[bond,Cweak] = addhydrogenbonds(bond,C,R,atoms,allowed);
	if ~all(C)
		bond = connectfragments(bond,Cweak,R,atoms,allowed);
	end
	bonds = genbonds(bond,C);
	angles = genangles(bond,xyz,C);
	dihs = gendihs(bond,xyz,C,bonds);
	coords = [bonds; angles; dihs];
	if geom.periodic
		coords = reduce(coords,geom.n); % erase periodic images
	end
	coordanalysis(coords,length(frags));
	coords = coords(:,1:4);
	rho = exp(-R./cov+1); % matrix of covalent measure
end

function [bond,C,frags,cov] = covalentbond(R,atoms,allowed)
	n = length(atoms);
	cov = radius(atoms,'covalent');
	cov = cov(:,ones(1,n))+cov(:,ones(1,n))'; % covalent distances
	bond = R<1.3*cov; % bond matrix
	bond(logical(eye(n))) = false;
	bond = onlyallowed(bond,allowed,atoms,R);				
	[C,frags] = conn(bond); % matrix of connectedness
end

function bonds = genbonds(bond,C)
	[left,right] = find(triu(bond));
	bonds(:,[1 2 5]) = [left right ~C(triu(bond))];
end

function angles = genangles(bond,xyz,C)
	n = size(bond,1);
	N = sum(bond,2);
	angles = zeros(sum(N.*(N-1)/2,1),5);
	iang = 0;
	for i = 1:n % cycle through atoms
		neigh = find(bond(:,i)); % neighbours of the atom
		m = length(neigh);
		for j = 1:m % cycle through unique pairs of neighbours
			for k = 1:j-1
				if ang(xyz([neigh(j) i neigh(k)],:)) > pi/4
					iang = iang+1;
					angles(iang,[1 2 3 5]) = ...
						[neigh(j) i neigh(k) ~C(neigh(j),i)+~C(i,neigh(k))];
				end
			end
		end
	end
	angles = angles(1:iang,:);
end
	
function dihs = gendihs(bond,xyz,C,bonds)
	n = size(bonds,1);
	dihs = [];
	idih = 0;
	for i = 1:n
		[dihs,idih] = makedih(dihs,idih,bonds(i,1:2),bond,xyz,C);
	end
	dihs = dihs(1:idih,:);
end
