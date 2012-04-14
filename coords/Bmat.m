% calculates Wilson matrix. 12/04/09

function B = Bmat(geom,ind)
	global angstrom
	n = geom.n;
	m = size(ind,1);
	B = zeros(m,3*n);
	if geom.periodic
		xyz = copycell(geom.xyz,geom.abc,[-1 1; -1 1; -1 1])*angstrom;
	else
		xyz = geom.xyz*angstrom;
	end
	for i = 1:m
		if ind(i,3) == 0
			[void,grad] = r(xyz(ind(i,1:2),:),'grad');
		elseif ind(i,4) == 0
			[void,grad] = ang(xyz(ind(i,1:3),:),'grad');
		else
			[void,grad] = dih(xyz(ind(i,1:4),:),'grad');
		end
		indsub = mod(ind(i,1:4)-1,n)+1; % index in base cell
		k = size(grad,1);
		for j = 1:k
			pos = 3*(indsub(j)-1)+1;
			B(i,pos:pos+2) = B(i,pos:pos+2)+grad(j,:);
		end
	end
end
