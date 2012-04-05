function x = rms(A)
	x = sqrt(sum(sum(A.^2))/numel(A));
end
