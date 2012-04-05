% converts a number of an atom in a 2x2x2 supercell into a cell's jkl

function abc = atom2jkl(ind,m)
	abc = zeros(1,3);
	ind = floor((ind-1)/m);
	abc(1) = mod(ind,2);
	abc(2) = mod(floor(ind/2),2);
	abc(3) = mod(floor(ind/4),2);
end