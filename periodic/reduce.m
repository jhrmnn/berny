% reduces periodic copies of inner coordinates in supercell.
% 12/04/07

function ind = reduce(ind,m)
	astart = find(ind(:,3)~=0,1);
	dstart = find(ind(:,4)~=0,1);
	n = size(ind,1);
	k(1:astart-1) = 2;
	k(astart:dstart-1) = 3;
	k(dstart:n) = 4;
	keep = false(n,1);
	jkl = atom2jkl((1:27*m)',m);
	for i = 1:n
		switch k(i)
			case 2
				centre = round(sum(jkl(ind(i,1:2),:),1));
			case 3
				centre = round(2*jkl(ind(i,2),:));
			case 4
				centre = round(sum(jkl(ind(i,2:3),:),1));
		end
		if all(centre==0 | centre==-1)
			keep(i) = true;
		end
	end
	ind = ind(keep,:);
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
