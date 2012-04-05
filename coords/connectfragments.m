% connects fragments by a minimal number of bonds. The process is
% iterative. In each step, a pair of unconnected fragments with shortest 
% separation and those pairs with separation greater by no more than q(1) are 
% connected, by shortest interfragment bond and all bonds longer by no more
% than q(2). The process is repeated untill all fragments are connected.
function [bond,fragbonds] = connectfragments(fragments,R,q)
	nf = length(fragments);
	Rf = zeros(nf); % interfragment distances
	for i=1:nf
		for j=1:nf
			Rf(i,j) = min(min(R(fragments{i},fragments{j})));
		end
	end
	bondf = zeros(nf); % fragment bond matrix
	connf = eye(nf); % fragment connectedness matrix
	bond = zeros(size(R)); % bond matrix of weak bonds
	while find(connf==0) % cycle until everything is connected
		Rf(logical(connf))=Inf; % infinite distance between already connected
		[a,b] = ind2sub(size(Rf),find(triu(Rf<min(Rf(:))+0.01+q(1))));
		% a(1),b(1) is the first pair of fragments to be bonded, 
		% (2),b(2) the second, and so on
		for i=1:length(a)
			Rlocal = R(fragments{a(i)},fragments{b(i)});
			% distance matrix for two fragments, it is NOT symmetric
			[c,d] = ind2sub(size(Rlocal),find(Rlocal<min(Rlocal(:))+0.01+q(2)));
			% fragments{a(i)}(c),fragments{b(i)}(d) are pairs of atoms from 
			% different fragments which will be bonded
			for j=1:length(c);
				bond(fragments{a(i)}(c(j)),fragments{b(i)}(d(j)))=1;
				bond(fragments{b(i)}(d(j)),fragments{a(i)}(c(j)))=1;
				% bonding...
			end
			bondf(a(i),b(i))=1; % mark fragments as bonded
			bondf(b(i),a(i))=1;
		end
		connf = conn(bondf); % update the connectedness matrix
	end
	fragbonds = zeros(length(find(bondf))/2,2);
	[fragbonds(:,1),fragbonds(:,2)] = ind2sub(size(bondf),find(triu(bondf)));
end