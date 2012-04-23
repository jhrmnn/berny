% generalized inverse of matrix. 12/04/12

function Ai = ginv(A)
	[U,S,V] = svd(A'*A);
	D = diag(S);
	thre1 = 1e-16;
	thre2 = 1e8;
	D(D<thre1) = thre1;
	gap = D./[D(2:end); thre1];
	[gap,n] = max(gap);
	if gap < thre2
		warning('Pseudoinverse gap of only: %.3g',gap);
	end
	D(n+1:end) = 0;
	D(1:n) = 1./D(1:n);
	Ai = U*diag(D)*V'*A';
end
	
