% corrects for full angle displacements

function dq = correct(dq)
	dq(dq>pi) = dq(dq>pi)-2*pi;
	dq(dq<-pi) = dq(dq<-pi)+2*pi;
end
