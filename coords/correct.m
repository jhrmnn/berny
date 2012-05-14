% corrects discrete changes in internal coordinates. 12/04/07

function q = correct(q,templ,coords,n)
	ind = indexing(coords);
	dih = ind(3):ind(4)-1;
	circ = ind(3)-1+find(abs(abs(q(dih)-templ(dih))-2*pi)<pi/2);
	top = ind(3)-1+find(abs(abs(q(dih)-templ(dih))-pi)<pi/2);
	for i = 1:length(circ)
		k = circ(i);
		q(k) = q(k)+2*pi*sign(templ(k)-q(k));
	end
	if isempty(top), return, end
	for i = 1:length(top)
		k = top(i);
		q(k) = q(k)+pi*sign(templ(k)-q(k));
	end
	coords(coords>0) = mod(coords(coords>0)-1,n)+1;
	angs = unique(order([coords(top,1:3); coords(top,2:4)]),'rows');
	for i = 1:size(angs,1)
		loc = findangle(angs(i,:),coords(dih,:))+ind(3)-1;
		if all(ismember(loc,top))
			k = findangle(angs(i,:),coords(ind(2):ind(3)-1,1:3))+ind(2)-1;
			if abs(pi-q(k)) < pi/36
				q(k) = 2*pi-q(k);
			end
		end
	end
end

function ind = findangle(a,dihs)
	n = size(dihs,1);
	k = false(n,1);
	switch size(dihs,2)
		case 3
			for i = 1:n
				k(i) = all(a==dihs(i,:)) || all(a==dihs(i,[3 2 1]));
			end
		case 4
			for i = 1:n
				k(i) = all(a==dihs(i,1:3)) || all(a==dihs(i,[3 2 1]))...
					|| all(a==dihs(i,2:4)) || all(a==dihs(i,[4 3 2]));
			end
	end
	ind = find(k);
end		

function ang = order(ang)
	swap = ang(:,1)<ang(:,3);
	[ang(swap,1),ang(swap,3)] = deal(ang(swap,3),ang(swap,1));
end
