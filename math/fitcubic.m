% fits cubic polynomial to function values and derivatives at x=0,1
% returns position and function value of minimum or NaN if 1) polynomial
% doesn't have extrema, 2) maximum is between 0,1, or 3) maximum is 
% closer to 0.5 than minimum

function [x y] = fitcubic(y0,y1,g0,g1)
	a = 2*(y0-y1)+g0+g1;
	b = -3*(y0-y1)-2*g0-g1;
	p = [a b g0 y0]; % fitted polynomial
	r = roots(polyder(p)); % stationary points
	if isreal(r) % has extrema?
		r = sort(r);
		if p(1)>0
			x = r(2);
			maxim = r(1);
		else
			x = r(1);
			maxim = r(2);
		end
		y = polyval(p,x);
		if ((maxim > 0 && maxim < 1) || abs(x-.5)>abs(maxim-.5))
			x = NaN;
			y = NaN;
		end
	else
		x = NaN;
		y = NaN;
	end
end
