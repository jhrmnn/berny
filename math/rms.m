% RMS. 12/04/12

function x = rms(A)
	if isempty(A)
		x = []; return
	end
	x = sqrt(sum(A(:).^2)/numel(A));
end
