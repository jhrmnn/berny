% approximate Hessian from Swart '06. 12/04/06

function H = hessian(rho,ind)
	n = size(ind,1);
	H = zeros(n);
	for i=1:n
		if ind(i,3)==0
			H(i,i) = 0.45*rho(ind(i,1),ind(i,2));
		elseif ind(i,4)==0
			H(i,i) = 0.15*rho(ind(i,1),ind(i,2))...
				*rho(ind(i,2),ind(i,3));
		else
			H(i,i) = 0.005*rho(ind(i,1),ind(i,2))...
				*rho(ind(i,2),ind(i,3))*rho(ind(i,3),ind(i,4));
		end
	end
end
