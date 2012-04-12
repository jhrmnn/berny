% performs linear search based on Gaussian's algorithm.
% 12/04/12

function [t ei] = linearsearch(e0,e1,f0,f1)
	print('Linear interpolation:');
	print('* Energies: %4.6f, %4.6f',e0,e1);
	print('* Derivatives: %g, %g',f0,f1);
	msg = [];
	[t ei] = fitquartic(e0,e1,f0,f1);
	if isnan(t) || t < -1 || t > 2
		[t ei] = fitcubic(e0,e1,f0,f1);
		if isnan(t) || t < 0 || t > 1
			if e0 <= e1
				print('* No fit succeeded, staying in new point');
				t = 0;
				ei = e0;
			else
				print('* No fit succeeded, returning to best point');
				t = 1;
				ei = e1;
			end
		else
			msg = 'Cubic interpolation was performed';
		end
	else
		msg = 'Quartic interpolation was performed';
	end
	if ~isempty(msg)
		print('* %s: t = %g',msg,t);
		print('* Interpolated energy: %4.6f',ei);
	end
end
