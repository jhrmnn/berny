% converts Z-matrix from a.u. to angstrom/angles and vice versa.
% 12/04/17

function zmat = zunits(zmat,type)
	angstrom = 1.88972613288;
	switch type
		case 'toau'
			Q = [angstrom pi/180];
		case 'toangstrom'
			Q = [1/angstrom 180/pi];
	end
	n = size(zmat.def,1);
	m = length(zmat.var);
	changed = false(m,1);
	for i = 2:n
		if zmat.def(i,3) > -1000
			zmat.def(i,3) = zmat.def(i,3)*Q(1);
		else
			k = -zmat.def(i,3)-1000;
			if changed(k), continue, end
			zmat.var(k) = zmat.var(k)*Q(1);
			changed(k) = true;
		end
	end
	for i = 3:n
		if zmat.def(i,5) > -1000
			zmat.def(i,5) = zmat.def(i,5)*Q(2);
		else
			k = -zmat.def(i,5)-1000;
			if changed(k), continue, end
			zmat.var(k) = zmat.var(k)*Q(2);
			changed(k) = true;
		end
	end
	for i = 4:n
		if zmat.def(i,7) > -1000
			zmat.def(i,7) = zmat.def(i,7)*Q(2);
		else
			k = -zmat.def(i,7)-1000;
			if changed(k), continue, end
			zmat.var(k) = zmat.var(k)*Q(2);
			changed(k) = true;
		end
	end
end
