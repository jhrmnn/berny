% recursive function. It constructs dihedrals for a given central edge
% (atoms 2,3). If it encountres a linear angle on the end (not the start) 
% of the edge, it extends the edge and calls itself.
function [dihedrals,idih] = dihedralmaker(...
                            idih,edge,bond,xyz,C,dihedrals,nweak)
	neigh{1} = find(bond(:,edge(1))); % neighbours of edge's margins
	neigh{2} = find(bond(:,edge(end)));
	neigh{1}(neigh{1}==edge(2))=[]; % discard the edge atoms
	neigh{2}(neigh{2}==edge(end-1))=[];
	for j=1:length(neigh{1}) % cycle through all neigbour pairs
		for k=1:length(neigh{2})
			anglea = angquick(xyz([neigh{1}(j) edge(1:2)],:)); % trailing angles
			angleb = angquick(xyz([edge(end-1:end) neigh{2}(k)],:));
			if anglea > pi-1e-6
				continue % linear angle on the start of the edge is of no interest
			elseif angleb > pi-1e-6
				edge(end+1) = neigh{2}(k); % extend the edge
				[dihedrals,idih] = dihedralmaker(idih,edge,bond,xyz,C,dihedrals,...
															    nweak+~C(edge(end),edge(end-1)));
			elseif neigh{1}(j)>=neigh{2}(k)
				continue % no interest in reversed or cyclic dihedrals
			elseif anglea>pi/4 && angleb>pi/4
				nweakthis = nweak+~C(neigh{1}(j),edge(1))...
				                 +~C(edge(end),neigh{2}(k));
				% added weakness of tails
				dihedrals(idih,:) = [neigh{1}(j) edge(1)...
				                     edge(end) neigh{2}(k) nweakthis];
				% after so many checks, finally adds the dihedral
				idih = idih+1;
				if dihedrals(end,1)
					dihedrals = [dihedrals; zeros(1000,5)];
				end
			end
		end
	end
end

function Phi = angquick(xyz,grad)
	v1 = xyz(1,:)-xyz(2,:);
	v2 = xyz(3,:)-xyz(2,:);
	Phi = acos(v1*v2'/norm(v1)/norm(v2));
end