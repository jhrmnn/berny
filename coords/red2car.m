% AWFUL, TO BE POLISHED

function [x,q] = red2car(q,ind,geom)
	global bohr
	if geom.periodic
		abc = geom.abc;
	else
		abc = eye(3);
	end
	x = geom.xyz;
	n = geom.n;
	dq = q.total;
	q = q.now;
	qtarget = q+dq;
	i = 0;
	err = rms(dq);
	thre = 1e-7;
	maxrms = 0.01;
	maxit = 10000;
	while true % break in the loop
		xlast = x;
		qlast = q;
		if rms(dq) > maxrms
			Q = maxrms/rms(dq);
		else
			Q = 1;
		end
		B = Bmat(geom,ind);
		x = x(1:n,:)+Q*bohr*reshape(llsqr(size(B,1),size(B,2),B,dq,0,1e-9,1e-9,1e8,maxit,0),3,n)'; % iteration step
		q = internals(struct('xyz',x,'abc',abc,'periodic',geom.periodic),ind);
    a = find(abs(correct(q-qlast))>2);
    q(a)=q(a)-pi*sign(correct(q(a)-qlast(a)));
		dq = correct(qtarget-q); % new step in internals
		errlast = err;
		err = rms(dq(abs(correct(q-qlast))<pi-3*maxrms));
		i = i+1;
		if err < thre
			print('Perfect transformation in %i iterations: rms(dq)=%g, max(abs(dq))=%g\n',i,err,max(abs(dq)));
			break
		elseif i > 1
			if errlast-err < thre
				print('Transformation ceases to improve after %i iterations: rms(dq)=%g, max(abs(dq))=%g\n',i,errlast,max(abs(correct(qtarget-qlast))));
				if errlast < err
					x = xlast;
					q = qlast;
				end
				break
			end
		end
	end
end
