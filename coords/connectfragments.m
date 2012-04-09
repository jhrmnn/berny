% connects unnconected molecular fragments. 12/04/09

function bond = connectfragments(bond,C,R,atoms,allowed)
	n = length(atoms);
	vdw = radius(atoms,'vdw');
	vdw = vdw(:,ones(1,n))+vdw(:,ones(1,n))'; % vdW distances
	q = 1;
	while ~all(C)
		bond = bond | (~C & R<q*vdw);
		bond = onlyallowed(bond,allowed,atoms,R);					
		q = q+0.1;
		C = conn(bond);
	end
end
