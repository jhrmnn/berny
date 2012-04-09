function [t ei] = linearsearch(q,e,g)
	e0 = e.best;
	e1 = e.now;
	f0 = g.best'*correct(q.now-q.best);
	f1 = g.now'*correct(q.now-q.best);
	print('Linear interpolation:\n');
	print('* Energies: %4.6f, %4.6f\n',e0,e1);
	print('* Derivatives: %g, %g\n',f0,f1);
	[t ei] = fitquartic(e0,e1,f0,f1); % quartic fit
	if ~(isnan(t) || ~(t > -1 && t < 2))
		print('* Quartic interpolation was performed: t=%g\n',t);
	else
		[t ei] = fitcubic(e0,e1,f0,f1); % cubic fit
		if ~(isnan(t) || ~(t > 0 && t < 1) || e0 == e1)
			print('* Cubic interpolation was performed: t=%g\n',t);
		else
			if e1 <= e0
				print('* Linear search stays in new point.\n');
				t = 1;
				ei = e1;
			else
				print('* Wrong quadratic step, staying in best point.\n');
				t = 0;
				ei = e0;
			end
		end
	end
	print('* Interpolated energy: %4.6f\n',ei);
end
