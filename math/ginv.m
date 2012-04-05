% generalized inverse of matrix

function A = ginv(A)
	[U,S,V] = svd(A);
	U = real(U);
	V = real(V);
	D = diag(real(S));
	Dsorted = sort(abs(D));
	thre = 1e-10;
	while true
			i = find(Dsorted>thre,1);
			if i==1
				break
			end
			if Dsorted(i)/Dsorted(i-1)<1000
					thre=10*thre;
			else
					break
			end
			if thre > 0.1
					error('I cannot make the generalized inverse')
			end
	end
	print('Generalized inverse: %.3e, %.3e\n',Dsorted([i-1 i]));
	D(abs(D)<thre) = 0;
	D(abs(D)>0) = 1./D(abs(D)>0);
	A = V*diag(D)*U';
end
	
