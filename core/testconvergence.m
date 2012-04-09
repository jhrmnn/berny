function isconverged = testconvergence(g,dq,threshold)
	values = [max(abs(g)) rms(g) max(abs(dq)) rms(dq)];
	names = {'Gradient maximum' 'Gradient RMS' 'Previous step maximum' 'Previous step RMS'};
	flags = zeros(1,4);
	print('Convergence criteria:\n');
	for i=1:4
		if values(i) < threshold(i) && values(i) ~= 0
			b = 'OK';
			flags(i) = 1;
		else
			b = 'no';
		end
		print(['* ' char(names(i))...
		        ' is: %g, threshold: %g, ' b '\n'], ...
		        values(i),threshold(i));
	end
	if all(flags)
		print('All criteria matched\n');
		isconverged = true;
	else
		isconverged = false;
	end
end
