function w = weights(xyz,q,ind,rho)
	w = zeros(size(q,1));
	n = size(q,1);
	f = 0.12;
	for i=1:n
		if ind(i,3)==0
			w(i,i) = rho(ind(i,1),ind(i,2));
		elseif ind(i,4)==0
			w(i,i) = sqrt(rho(ind(i,1),ind(i,2))*rho(ind(i,2),ind(i,3)))...
				*(f+(1-f)*sin(q(i)));
		else
			th1 = ang(xyz(ind(i,1:3),:));
			th2 = ang(xyz(ind(i,2:4),:));
			w(i,i) = (rho(ind(i,1),ind(i,2))*rho(ind(i,2),ind(i,3))...
				*rho(ind(i,3),ind(i,4)))^(1/3)...
				*(f+(1-f)*sin(th1))*(f+(1-f)*sin(th2));
		end
	end
end
