function loadvar(var)
	s = fieldnames(var);
	for i = 1:length(s)
		assignin('caller',s{i},var.(s{i}));
	end
end
