% connects unnconected molecular fragments. 12/04/09

function bond = connectfragments(bond,C,R,atoms,allowed)
	n = length(atoms);
	vdw = radius(atoms,'vdw');
	vdw = vdw(:,ones(1,n))+vdw(:,ones(1,n))'; % vdW distances
	q = 1; % quotient
	while ~all(C) % while not connected
		bond = bond | (~C & R<q*vdw); % add bonds shorted than q*vdW
		bond = onlyallowed(bond,allowed,atoms,R);
		C = conn(bond);
		q = q+0.1; % increase quotient
	end
end
