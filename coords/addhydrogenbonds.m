% add hydrogen bonds to bond matrix. 12/04/09

function [bond,C] = addhydrogenbonds(bond,C,R,atoms,allowed)
	H = find(atoms==1); % H atoms
	O = find(atoms==8); % O atoms
	[Oi,Hi] = find(~C(O,H) & R(O,H)<2.0);
	                         % find O-H shorted than 2 angstroms
	if isempty(Hi), return, end
	H = H(Hi); % bonded H atoms
	O = O(Oi); % bonded H atoms
	for i = 1:length(H)
		if any(atoms(bond(H(i),:))==8) % if H covalently bonded to O
			bond(O(i),H(i)) = true; % make hydrogen bond
			bond(H(i),O(i)) = true;
		end
	end
	bond = onlyallowed(bond,allowed,atoms,R);
	C = conn(bond);
end
