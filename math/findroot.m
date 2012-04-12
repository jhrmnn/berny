% finds root of increasing function fun on (-inf,lim),
% fun(-inf) < 0, fun(lim) > 0

function x = findroot(f,lim)
	d = 1; % lim-d will be initial guess
	while f(lim-d) < 0
		d = d/2; % find d so that lim-d > 0
	end
	x = lim-d; % initial guess
	dx = 1e-10; % step for numerical derivative
	
	fx = f(x);
	err = abs(fx);
	while true
		fxpdx = f(x+dx);
		dxf = (fxpdx-fx)/dx; % derivative
		x = x-fx/dxf; % update
		fx = f(x);
		errnew = abs(fx);
		if errnew >= err, break, end
		err = errnew;
	end
end
