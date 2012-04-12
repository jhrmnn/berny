% prints information about coordinates. 12/04/07

function coordanalysis(ind,nfrag)
	m = size(ind,1);
	print('Coordinates information:');
	print('* Number of fragments (in supercell): %g',nfrag);
	print('* Number of internal coordinates: %g',m);
	idih = find(ind(:,4),1);
	if isempty(idih), idih = m+1; end
	iangle = find(ind(:,3),1);
	if isempty(iangle), iangle = idih; end
	i = [1 iangle idih m+1];
	ind(ind(:,5)>2,:) = 2; % reduce degrees to max 2
	degrees = [2 3 3];
	names = {'bonds' 'angles' 'dihedrals'};
	adjectives = {'strong' 'weak' 'superweak'};
	for k = 1:3
		for l = 1:degrees(k)
			number = length(find(ind(i(k):i(k+1)-1,5)==l-1));
			if number > 0
				print('* Number of %s %s: %g',...
					adjectives{l},names{k},number);
			end
		end
	end
end
