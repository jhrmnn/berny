% corrects for full angle displacements. 12/04/07

function dq = correct(dq)
	dq(dq>pi) = dq(dq>pi)-2*pi;
	dq(dq<-pi) = dq(dq<-pi)+2*pi;
end
