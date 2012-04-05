% fits constrained quartic polynomial to function values and derivatives 
% at x=0,1. quartic polynomial is constrained such that it's 2nd derivative
% is zero at just one point. this ensures that it has just one maximum or 
% one minimum. no such or two such quartic polynomials always exist. from 
% the two, the one with lower minimum is chosen returns position and 
% function value of minimum or NaN if fit fails or has a maximum

function [x y] = fitquartic(y0, y1, g0, g1)
	D = -(g0+g1)^2 - 2*g0*g1 + 6*(y1-y0)*(g0+g1) - 6*(y1-y0)^2;
		% discriminant of d^2y/dx^2=0
	if D < 1e-11
		x = NaN;
		y = NaN;
		return
	else
		m = -5*g0 - g1 - 6*y0 + 6*y1;
		p1 = helper(y0, y1, g0, g1, .5*(m+sqrt(2*D)));
		p2 = helper(y0, y1, g0, g1, .5*(m-sqrt(2*D)));
		if (p1(1) < 0 && p2(1) < 0)
			x = NaN;
			y = NaN;
			return
		end
		[x1 minim1] = min(p1);
		[x2 minim2] = min(p2);
		if minim1 < minim2 % choose the one with lower minimum
			x = x1;
			y = minim1;
		else
			x = x2;
			y = minim2;
		end
	end
end

function p = helper(y0, y1, g0, g1, c)
	a = c + 3*(y0-y1) + 2*g0 + g1;
	b = -2*c - 4*(y0-y1) - 3*g0 - g1;
	p = [a b c g0 y0];
end

% returns minimum of constrained quartic
function [x y] = min(p)
	r = roots(polyder(p));
	reals = (conj(r).*r-r.*r == 0);
	if sum(reals) == 1
		x = r(reals);
	else
		x = r(logical((r==max(-abs(r)))+(r==-max(-abs(r)))));
	end
	y = polyval(p, x);
end

