% finds fragments and makes connection matrix. 12/04/07

function [C,frags] = conn(C)
	n = size(C,1); % number of nodes
	found = zeros(n,1); % i-th node in found(i)-th fragment
	que = zeros(n,1); % queue of detected but not found fragments
	ifrag = 0; % fragments counter
	for i = 1:n % cycle through nodes
		if found(i), continue, end % if found, skip
		ifrag = ifrag+1; % new fragment
		que(1) = i; % enqueue the current node
		a = 1; % beginning of queue
		b = 1; % end of queue
		while b-a >= 0 % while que not empty
			node = que(a); % dequeue node
			a = a+1;
			found(node) = ifrag; % label as found
			succ = find(C(node,:)); % find successors
			for j = 1:length(succ) % cycle through succesors
				if found(succ(j)) || any(que(a:b)==succ(j)), continue, end
					% if successor found or enqueued, skip
				b = b+1;
				que(b) = succ(j); % enqueue succesor
			end
		end
	end
	frags = cell(1,ifrag);
	for i = 1:ifrag
		frags{i} = find(found==i);
		C(frags{i},frags{i}) = true;
	end
end
