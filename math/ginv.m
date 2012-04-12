% generalized inverse of matrix. 12/04/12

function A = ginv(A)
	[U,S,V] = svd(A);
	D = diag(S);
	thre1 = 1e-14;
	thre2 = 1000;
	thre3 = 1e8;
	while true
		i = find(D<thre1,1);
		if isempty(i)
			i = length(D);
		end
		if i == 1
			error('Cannot make generalized inverse of zero matrix');
		end
		gap = D(i-1)/D(i);
		if gap > thre2, break, end
		thre1 = 10*thre1;
		if thre1 >= D(1)
			error('Pseudoinverse: there is nowhere a gap of %g',gap);
		end
	end
	if gap < thre3
		print('! Warning: Pseudoinverse gap: %.3g',gap);
	end
	D(D<thre1) = 0;
	D(D>0) = 1./D(D>0);
	A = V*diag(D)*U';
end
	
