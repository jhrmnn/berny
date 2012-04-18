% transforms step in internals into Z-matrix. 12/04/16

function [var,q] = red2zmat(dq,q,Bi,geom,coords)
	var = geom.zmat.var;
	thre = 1e-6;
	maxit = 20;
	err = rms(dq);
	qtarget = q+dq;
	i = 0;
	trust = 0.5;
	while true
		i = i+1;
		geom.zmat.var = var+trust*Bi*dq;
		qnew = internals(geom,coords);
		dqnew = correct(qtarget-qnew);
		errnew = rms(dqnew);
		fletcher = err/errnew;
		if fletcher > 1 && trust < 0.5
			trust = 2*trust;
		elseif fletcher < 1
			trust = trust/2;
		end
		dvar = rms(geom.zmat.var-var);
		var = geom.zmat.var;
		q = qnew;
		dq = dqnew;
		err = errnew;
		if dvar < thre
			msg = 'Perfect transformation to Z-matrix in %i iterations';
			break
		end
		if i >= maxit
			msg = 'Transformation to Z-matrix terminated after %ith iteration';
			break
		end
	end
	print(msg,i);
	print('* RMS(dzmat): %.3g, RMS(dq): %.3g',dvar,err);
end
