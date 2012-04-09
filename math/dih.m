% 12/04/09

function [Phi,grad] = dih(xyz,grad)
	v1 = xyz(1,:)-xyz(2,:);
	v2 = xyz(4,:)-xyz(3,:);
	w = xyz(3,:)-xyz(2,:);
	ew = w/norm(w);
	a1 = v1-(v1*ew')*ew;
	a2 = v2-(v2*ew')*ew;
	sgn = sign(det([v2; v1; w]));
	if ~sgn
		sgn = 1;
	end
	sc = a1*a2'/norm(a1)/norm(a2);
	if sc <= -1
		sc = -1;
	elseif sc >= 1
		sc = 1;
	end
	Phi = acos(sc)*sgn;
	if nargin == 1, return, end
	grad = zeros(4,3);
	if norm(Phi) > pi-1e-6 % limit case for phi = 180
		g = cross(w,a1);
		g = g/norm(g);
		grad(1,:) = g/norm(g)/norm(a1);
		grad(4,:) = g/norm(g)/norm(a2);
		A = v1*ew'/norm(w);
		B = v2*ew'/norm(w);
		grad(3,:) = -((1+B)/norm(a2)+A/norm(a1))*g;
		grad(2,:) = -((1-A)/norm(a1)-B/norm(a2))*g;
	elseif norm(Phi) < 1e-6 % limit case for phi = 0
		g = cross(w,a1);
		g = g/norm(g);
		grad(1,:) = g/norm(g)/norm(a1);
		grad(4,:) = -g/norm(g)/norm(a2);
		A = v1*ew'/norm(w);
		B = v2*ew'/norm(w);
		grad(3,:) = ((1+B)/norm(a2)-A/norm(a1))*g;
		grad(2,:) = -((1-A)/norm(a1)+B/norm(a2))*g;
	else
		grad(1,:) = cot(Phi)*a1/norm(a1)^2 - a2/(norm(a1)*norm(a2)*sin(Phi));
		grad(4,:) = cot(Phi)*a2/norm(a2)^2 - a1/(norm(a1)*norm(a2)*sin(Phi));
		A = v1*ew'/norm(w);
		B = v2*ew'/norm(w);
		grad(3,:) = ((1+B)*a1+A*a2)/(norm(a1)*norm(a2)*sin(Phi)) ...
			- cot(Phi)*((1+B)*a2/norm(a2)^2+A*a1/norm(a1)^2);
		grad(2,:) = ((1-A)*a2-B*a1)/(norm(a1)*norm(a2)*sin(Phi)) ...
			- cot(Phi)*((1-A)*a1/norm(a1)^2-B*a2/norm(a2)^2);
	end
end

function c = cross(a,b)
	c = [a(2)*b(3)-a(3)*b(2);...
		a(3)*b(1)-a(1)*b(3);...
		a(1)*b(2)-a(2)*b(1)];
end
