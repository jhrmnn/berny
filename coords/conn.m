% gives a connectedness matrix from a bond or whatever inbetween
% matrix

function C = conn(C)
	while true
		CC = double(logical(C*C+C+eye(size(C))));
		if CC == C
			break
		else
			C = CC;
		end
	end
end
