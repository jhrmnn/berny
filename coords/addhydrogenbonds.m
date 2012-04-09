% add hydrogen bonds to bond matrix. 12/04/09

function [bond,C] = addhydrogenbonds(bond,C,R,atoms,allowed)
	H = find(atoms==1);
	O = find(atoms==8);
	[Oi,Hi] = find(~C(O,H) & R(O,H)<2.0);
	if isempty(Hi), return, end
	H = H(Hi);
	O = O(Oi);
	for i = 1:length(H)
		if any(atoms(bond(H(i),:))==8)
			bond(O(i),H(i)) = true;
			bond(H(i),O(i)) = true;
		end
	end
	bond = onlyallowed(bond,allowed,atoms,R);		
	C = conn(bond);
end
