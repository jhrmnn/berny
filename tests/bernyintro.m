% performs the first few lines of berny algorithm. For testing
% purposes. 12/04/12

function Gi = bernyintro(geom)
	global fid
	load berny.mat coords
	B = Bmat(geom,coords);
	G = B*B'; 
	Gi = ginv(G);
	if fid > 0, fclose(fid); end
end
