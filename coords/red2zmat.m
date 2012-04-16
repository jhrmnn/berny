% transforms step in internals into Z-matrix. 12/04/16

function [var,q] = red2zmat(dq,q,Bi,geom,coords)
	xyz = geom.xyz;
	var = geom.zmat.var;
	thre = 1e-6;
	thre2 = 1e-14;
	maxit = 20;
	err = rms(dq);
	qtarget = q+dq;
	wasrecalc = false;
	i = 0;
	while true
		i = i+1;
		geom.zmat.var = var+0.5*Bi*dq;
		geom.xyz = zmat2xyz(geom.zmat);
		qnew = internals(geom,coords);
		dqnew = correct(qtarget-qnew);
		errnew = rms(dqnew);
		if errnew > err+thre2 && ~wasrecalc
			geom.xyz = xyz;
			geom.zmat.var = var;
			B = Bmat(geom,coords)*zmatgrad(geom.zmat)';
			Bi = B'*ginv(B*B')';
			wasrecalc = true;
			i = i-1;
			continue
		end
		wasrecalc = false;
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
