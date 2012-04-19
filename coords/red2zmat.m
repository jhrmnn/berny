% transforms step in internals into Z-matrix. 12/04/16

function [var,q] = red2zmat(dq,q,Bi,geom,coords)
	var = geom.zmat.var;
	thre = 1e-6;
	maxit = 20;
	err = rms(dq);
	qtarget = q+dq;
	i = 0;
	while true
		i = i+1;
		geom.zmat.var = var+0.5*Bi*dq;
		qnew = internals(geom,coords);
		dqnew = correct(qtarget-qnew);
		errnew = rms(dqnew);
		dvar = rms(geom.zmat.var-var);
		var = geom.zmat.var;
		q = qnew;
		dq = dqnew;
		err = errnew;
		if dvar < thre
			msg = 'Perfect transformation to Z-matrix in %i iterations';
			break
		end
		if i == 1
			[var1,q1,dvar1,err1] = deal(var,q,dvar,err);
		end
		if i >= maxit
			msg = 'Transformation did not converge in %i iterations';
			[var,q,dvar,err] = deal(var1,q1,dvar1,err1);
			break
		end
	end
	print(msg,i);
	print('* RMS(dzmat): %.3g, RMS(dq): %.3g',dvar,err);
end
