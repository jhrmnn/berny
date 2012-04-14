% makes trust-constrained NR step. 12/04/12

function [dq,deP] = quadraticstep(g,H,w,trust)
	ev = eig((H+H')/2);
	rfo = [H g; g' 0];
	[V,D] = eig((rfo+rfo')/2);
	dq = V(1:end-1,1)/V(end,1);
	l = D(1);
	if norm(dq) <= trust
		print('Pure RFO step was performed:');
	else
		steplength = @(l)(norm((l*eye(size(H))-H)\g)-trust);
		l = findroot(steplength,ev(1)); % minimization on sphere
		dq = (l*eye(size(H))-H)\g;
		print('Minimization on sphere was performed:');
	end
	print('* Trust radius: %.3g',trust);
	print('* Number of negative eigenvalues: %i',...
		length(find(ev<0)));
	print('* Lowest eigenvalue: %.3g',ev(1));
	print('* lambda: %.3g',l);
	deP = g'*dq+0.5*dq'*H*dq; % predicted energy change
	print('Quadratic step: RMS: %.3g, max: %.3g',...
		rms(dq),max(abs(dq)));
	print('* Predicted energy change: %.3g',deP);
end
