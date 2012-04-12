% fits cubic polynomial to function values and derivatives
% at x = 0,1 and returns position and function value of minimum or 
% NaN if i) polynomial doesn't have extrema or ii) maximum 
% is from (0,1), or iii) maximum is closer to 0.5 than minimum.
% 12/04/12

function [x,y] = fitcubic(y0,y1,g0,g1)
	a = 2*(y0-y1)+g0+g1;
	b = -3*(y0-y1)-2*g0-g1;
	p = [a b g0 y0]; % fitted polynomial
	r = roots(polyder(p)); % stationary points
	if isempty(r)
		[x,y] = deal(NaN);
		return
	end
	if isreal(r) % has extrema?
		r = num2cell(sort(r));
		if p(1) > 0
			[max,x] = r{:};
		else
			[x,max] = r{:};
		end
		if (max > 0 && max < 1) || abs(x-0.5) > abs(max-0.5)
			[x,y] = deal(NaN);
			return
		end
		y = polyval(p,x);
	else
		[x,y] = deal(NaN);
	end
end
