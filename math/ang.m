function [Phi,grad] = ang(xyz,grad)
	v1 = xyz(1,:)-xyz(2,:);
	v2 = xyz(3,:)-xyz(2,:);
	Phi = acos(v1*v2'/norm(v1)/norm(v2));
	if ~exist('grad','var')
		return
	end
	grad = zeros(3,3);
	if norm(Phi)>pi-1e-6 % limit case for phi=180
		grad(1,:) = (pi-Phi)/(2*norm(v1)^2)*v1;
		grad(3,:) = (pi-Phi)/(2*norm(v2)^2)*v2;
		grad(2,:) = (1/norm(v1)-1/norm(v2))*(pi-Phi)/(2*norm(v1))*v1;
	else
		grad(1,:) = cot(Phi)*v1/norm(v1)^2 - v2/(norm(v1)*norm(v2)*sin(Phi));
		grad(3,:) = cot(Phi)*v2/norm(v2)^2 - v1/(norm(v1)*norm(v2)*sin(Phi));
		grad(2,:) = (v1+v2)/(norm(v1)*norm(v2)*sin(Phi)) ...
			- cot(Phi)*(v1/norm(v1)^2+v2/norm(v2)^2);
	end
end
