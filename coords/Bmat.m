% calculates Wilson matrix

function B = Bmat(x,m,ind)
	global bohr
	
	n = size(ind,1); % number of coords
	x = x/bohr; % angstroms to bohrs
	B = zeros(n,3*m);
	for i=1:n
		if ind(i,3) == 0
			[void,grad] = r(x(ind(i,1:2),:),'gradient');
		elseif ind(i,4) == 0
			[void,grad] = ang(x(ind(i,1:3),:),'gradient');
		else
			[void,grad] = dih(x(ind(i,1:4),:),'gradient');
		end
		indsub = rem(ind(i,1:4)-1,m)+1;
		k = size(grad,1);
		for j=1:k
			pos = 1+3*(indsub(j)-1);
			B(i,pos:pos+2) = B(i,pos:pos+2)+grad(j,:);
% 			jkl = atom2jkl(ind(i,j),m);
% 			for p=1:3
% 				pos = 3*m+1+(p-1)*3;
% 				B(i,pos:pos+2) = B(i,pos:pos+2)+jkl(p)*grad(j);
% 			end
		end
	end
end
