% updates Hessian. 12/04/12

function H = updatehessian(H,dq,dg)
	BFGS = dg*dg'/(dq'*dg)-H*(dq*dq')*H/(dq'*H*dq); % BFGS update
	%MS = (dg-H*dq)*(dg-H*dq)'/(dq'*(dg-H*dq)); % MS update
	%Q = abs(dq'*(dg-H*dq))/(norm(dq)*norm(dg-H*dq)); % Bofill's coeff
	%dH = (1-Q)*BFGS+Q*MS;
	dH = BFGS;
	H = H+dH;
	print('Hessian update information:');
	%print('* Bofill''s coefficient: %.3g',Q);
	print('* Change: RMS: %.3g, max: %.3g',rms(dH),max(abs(dH(:))));
end
