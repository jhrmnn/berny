function name = whichcluster()
	[stat,uname]=system('uname -n');
	if iscluster(uname,'iridium','i')
		name = 'iridium';
	elseif iscluster(uname,'mof','m')
		name = 'mof';
	elseif iscluster(uname,'vanad','v')
		name = 'vanad';
	else
		error('I don''t know this cluster')
	end
end

function is = iscluster(uname,name,l)
	is = ~isempty(regexp(uname,name,'once')) || ~isempty(regexp(uname,[l '\d\d'],'once'));
end
