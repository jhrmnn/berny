% generates system of internal coordinates based on standard covalent radii
% mind the terminology: two things are _bonded_ if there is a bond
% betwenen them. two things are _connected_ if there is a chain of bonds,
% that connects them

function [ind,rho,nfrag] = genind(xyz,atoms,allowed,m)
	n = length(atoms); % number of atoms
	R = dist(xyz); % matrix of interatomic distances, Inf on diagonal
	cov = zeros(n); % matrix of covalent distances, 2*Rcov on diagonal
	vdw = zeros(n); % matrix of vdw distances
	rad = zeros(n,2);
	for i=1:n
		rad(i,:) = radius(atoms{i});
	end
	for i=1:n
		for j=1:n
			cov(i,j) = rad(i,1)+rad(j,1);
			vdw(i,j) = rad(i,2)+rad(j,2);
		end
	end
	rho = exp(-R./cov+1); % matrix of covalent measure, 0 on diagonal
	bond = double(R<1.3*cov); % bond matrix, 0 on diagonal
	bond = onlyallowed(bond,allowed,atoms,m,R);					
	C = conn(bond); % matrix of connectedness, 1 on diagonal
	nfrag = length(findfragments(C));
	isOHO = zeros(n);
	for i=1:n
		neigh = find(bond(i,:));
		if strcmp(atoms{i},'H') && length(neigh)==1 &&...
		   strcmp(atoms{neigh},'O')
			for j=1:n
				if strcmp(atoms{j},'O') && j~=neigh
					isOHO(i,j) = 1;
					isOHO(j,i) = 1;
				end
			end
		end
	end
	bond = bond+~C.*isOHO.*double(R<2.0);
	bond = onlyallowed(bond,allowed,atoms,m,R);					
	Cvdw = conn(bond);
	q = 1;
	while find(Cvdw==0)
		nfrag(end+1) = length(findfragments(Cvdw));
		bond = bond+~Cvdw.*double(R<q*vdw);
		bond = onlyallowed(bond,allowed,atoms,m,R);					
		Cvdw = conn(bond);
		q = q+0.1;
	end
	ind = generatecoords(bond,C,xyz); % and this as well
end
