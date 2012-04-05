% calculates internal coordinates, see Bmat.m

function q = internals(x,ind)
	global bohr
	
	m = size(x,1);
	n = size(ind,1);
	q = zeros(n,1);
	x = x/bohr;
	for i=1:n
		if ind(i,3) == 0
			q(i) = r(x(ind(i,1:2),:));
		elseif ind(i,4) == 0
			q(i) = ang(x(ind(i,1:3),:));
		else
			q(i) = dih(x(ind(i,1:4),:));
		end
	end
end
