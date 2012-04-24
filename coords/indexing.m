% locates bonds, angles and dihedrals in coord

function i = indexing(ind)
	m = size(ind,1);
	idih = find(ind(:,4),1); % start of dihedrals
	if isempty(idih), idih = m+1; end % if no dihedrals
	iangle = find(ind(:,3),1); % start of angles
	if isempty(iangle), iangle = idih; end % if no angles
	i = [1 iangle idih m+1]; % indexing
end
