% find fragments from matrix of connectedness
function fragments = findfragments(C)
	n = size(C,1);
	v = zeros(n,1); % this holds info about unsorted atoms
	nf = 0; % number of fragments
	for i=1:n % cycle through atoms
		if v(i) == 0 % if it is already sorted (1), skip
			nf = nf+1;
			w = zeros(n,1);
			w(i) = 1; % this is current atom
			frag = find(C*w); % this gives all atoms from the same fragment
			v(frag) = 1; % set as sorted
			fragments{nf} = frag; % extract the info
		end
	end
end