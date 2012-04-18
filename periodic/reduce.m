% reduces periodic copies of inner coordinates in supercell.
% 12/04/07

function [ind,frags,atoms] = reduce(ind,frags,n)
	m = size(ind,1);
	idih = find(ind(:,4),1); % start of dihedrals
	if isempty(idih), idih = m+1; end % if no dihedrals
	iangle = find(ind(:,3),1); % start of angles
	if isempty(iangle), iangle = idih; end % if no angles
	k(1:iangle-1) = 2;
	k(iangle:idih-1) = 3;
	k(idih:m) = 4;
	keep = false(m,1);
	jkl = atom2jkl((1:27*n)',n);
	for i = 1:m
		switch k(i)
			case 2
				centre = round(sum(jkl(ind(i,1:2),:),1));
			case 3
				centre = round(2*jkl(ind(i,2),:));
			case 4
				centre = round(sum(jkl(ind(i,2:3),:),1));
		end
		if all((centre==0)|(centre==-1))
			keep(i) = true;
		end
	end
	ind = ind(keep,:);
	atoms = unique(ind(:,1:4));
	atoms = atoms(2:end); % discard zero
	n = length(frags);
	keep = false(n,1);
	for i = 1:n
		keep(i) = any(ismember(frags{i},atoms));
	end
	frags = frags(keep);
end

% converts a number of an atom in a 3x3x3 supercell into 
% a cell's jkl
function ijk = atom2jkl(atom,n)
	ind = floor((atom-1)/n);
	i = rem(ind,3);
	ind = round((ind-i)/3);
	j = rem(ind,3);
	k = round((ind-j)/3);
	ijk = [i j k]-1;
end
