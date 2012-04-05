function xyz = symmetrize(xyz,abc,symm,isfixed)
	global fixed
	A = inv(abc)';
	n = size(xyz,1);
	m = length(symm);
	xyzin = xyz;
	thre = 0.3./[norm(abc(1,:)) norm(abc(2,:)) norm(abc(3,:))];
	for i=1:n
		xyz(i,:) = (A*xyz(i,:)')'; % transforms to fractional
	end
	if exist('isfixed','var') && isfixed
		fixed.where = abs(mod(xyz,0.5))<1e-8;
		fixed.values = round(xyz(fixed.where)*2)/2;
	end
	v = zeros(n,1);
	for i=1:size(xyz,1)
		if ~v(i)
			equiv = zeros(m,4);
			symmed = zeros(m,3);
			for j=1:m
				symmed(j,:) = (symm{j}(:,1:3)*xyz(i,:)'+symm{j}(:,4))';
				delta = xyz-repmat(symmed(j,:),n,1);
				diff = abs(delta-round(delta));
				a = find(sum(diff<repmat(thre,size(diff,1),1),2)==3,1);
				if isempty(a)
					error('Cannot find the symmetry');
				elseif isempty(find(equiv(:,1)==a))
					equiv(j,:) = [a round(delta(a,:))];
					symmed(j,:) = (symm{j}(:,1:3)\(xyz(a,:)'-symm{j}(:,4)-round(delta(a,:))'))';
				end
			end
			v(equiv(equiv(:,1)~=0,1)) = 1;
			for i=1:3
				symmed(equiv(:,1)~=0,i) = mean(symmed(equiv(:,1)~=0,i));
			end
			for j=1:m
				if equiv(j,1) ~= 0
 					symmed(j,:) = (symm{j}(:,1:3)*symmed(j,:)'+symm{j}(:,4)+equiv(j,2:4)')';
				end
			end
			xyz(equiv(equiv(:,1)~=0,1),:) = symmed(equiv(:,1)~=0,:);
		end
	end
	if isstruct(fixed)
		xyz(fixed.where) = fixed.values;
	end
	for i=1:n
		xyz(i,:) = (abc'*xyz(i,:)')'; % transforms back to cartesian
	end
	diff = zeros(size(xyz,1),1);
	for i=1:length(diff)
		diff(i) = norm(xyzin(i,:)-xyz(i,:));
	end
	print('Symmetrization change. Max: %g, RMS: %g\n',...
					max(diff),rms(diff));
end		
