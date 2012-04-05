% returns standard covalent and van der waals radius of atom

function x = radius(s)
	switch s
		case 'H'
			x = [0.37 1.20];
		case 'B'
			x = [0.82 1.92];
		case 'C'
			x = [0.77 1.70];
		case 'N'
			x = [0.77 1.55];
		case 'O'
			x = [0.73 1.52];
		case 'F'
			x = [0.71 1.47];
		case 'Cl'
			x = [0.99 1.75];
		case 'Ag'
			x = [1.53 1.72];
		case 'Si'
			x = [1.11 2.10];
		case 'Al'
			x = [1.18 1.84];
		case 'Na'
			x = [1.54 2.27];
		case 'Cu'
			x = [1.32 1.40];
	end
end
