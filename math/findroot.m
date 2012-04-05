function x = findroot(fun,lim)
	d = 1;
	while fun(lim-d)<0
		d = d/2;
	end
	x = lim - d;
	dx = 1e-8;
	thre = 1e-6;
	while abs(fun(x))>thre
		g = (fun(x+dx)-fun(x))/dx;
		x = x - fun(x)/g;
	end
end
