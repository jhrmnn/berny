% corrects discrete changes in internal coordinates. 12/04/07

function q = correct(q,templ,coords)
	ind = indexing(coords);
	dih = ind(3):ind(4)-1;
	circ = ind(3)-1+find(abs(abs(q(dih)-templ(dih))-2*pi)<pi/2);
	top = ind(3)-1+find(abs(abs(q(dih)-templ(dih))-pi)<pi/2);
	for i = 1:length(circ)
		k = circ(i);
		q(k) = q(k)+2*pi*sign(templ(k)-q(k));
	end
	if isempty(top), return, end
	n = length(top);
	left = order(coords(top,1:3));
	right = order(coords(top,2:4));
	[lloc,lloc] = ismember([left zeros(n,1)],coords,'rows');
	[rloc,rloc] = ismember([right zeros(n,1)],coords,'rows');
	ang = unique([lloc; rloc]);
	swap = ang(pi-templ(ang)<pi/36);
	for i = 1:length(swap)
		k = swap(i);
		q(k) = 2*pi-q(k);
		ind = top(k==lloc|k==rloc);
		q(ind) = q(ind)+pi*sign(templ(ind)-q(ind));
	end
end

function ang = order(ang)
	swap = ang(:,1)<ang(:,3);
	[ang(swap,1),ang(swap,3)] = deal(ang(swap,3),ang(swap,1));
end
