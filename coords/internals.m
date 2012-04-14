% calculates internal coordinates. 12/04/09

function [q,w] = internals(geom,coords,rho)
	global angstrom
	m = size(coords,1);
	if geom.periodic
		xyz = copycell(geom.xyz,geom.abc,[-1 1; -1 1; -1 1])*angstrom;
	else
		xyz = geom.xyz*angstrom;
	end
	q = zeros(m,1);
	for i = 1:m
		if coords(i,3) == 0
			q(i) = r(xyz(coords(i,1:2),:));
		elseif coords(i,4) == 0
			q(i) = ang(xyz(coords(i,1:3),:));
		else
			q(i) = dih(xyz(coords(i,1:4),:));
		end
	end
	if nargin > 2
		w = weights(xyz,q,coords,rho);
	end
end

% gives weights of internal coordinates
function w = weights(xyz,q,ind,rho)
	m = size(q,1);
	w = zeros(m,1);
	f = 0.12;
	for i = 1:m
		if ind(i,3) == 0
			w(i) = rho(ind(i,1),ind(i,2));
		elseif ind(i,4) == 0
			w(i) = sqrt(rho(ind(i,1),ind(i,2))...
				*rho(ind(i,2),ind(i,3)))*(f+(1-f)*sin(q(i)));
		else
			th1 = ang(xyz(ind(i,1:3),:));
			th2 = ang(xyz(ind(i,2:4),:));
			w(i) = (rho(ind(i,1),ind(i,2))*rho(ind(i,2),ind(i,3))...
				*rho(ind(i,3),ind(i,4)))^(1/3)...
				*(f+(1-f)*sin(th1))*(f+(1-f)*sin(th2));
		end
	end
	w = diag(w);
end
