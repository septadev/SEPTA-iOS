use Modern::Perl;
use Data::Dumper; 

my $struct = q |

	public struct Route: Codable {
		public let routeId: String
		public let routeShortName: String
		public let routeLongName: String
		public let routeDirectionCode: RouteDirectionCode

		public init(routeId: String, routeShortName: String, routeLongName: String) {
			self.routeId = routeId
			self.routeShortName = routeShortName
			self.routeLongName = routeLongName
			self.route
		}
		|;

my @initVars = ();
my @vars = ();
while ($struct =~ m/(?:let|var)\s+(\w+)\s*:\s*([\w:\[\]\h]+)(\?*)\h*$/mg) {
	my $switchTemplate;
	if ($3) {
	$switchTemplate = qq |
	switch (lhs.$1, rhs.$1) {
	case (.none, .none):
		areEqual = true
	case (.some, .some):
		areEqual = lhs.$1! == rhs.$1!
	default:
		return false
	}
	guard areEqual else { return false }

	|;
	} else {
		$switchTemplate = qq |
		if lhs.$1 == rhs.$1 {
			areEqual = true
	} else {
		areEqual = false
		}
		guard areEqual else { return false }
|;
	}
	
	push @initVars, ["$1","$2$3"];
	push @vars, $switchTemplate;
}

my $varString = join "\n", @vars;

my $structName;
$struct =~ m/struct (\w+)/m; 
$structName = $1;

my $output = qq |
 extension $structName: Equatable {}
 func ==(lhs: $structName, rhs: $structName) -> Bool {
	var areEqual = true
	
	$varString
	return areEqual
	}
|;

say  $output;

my $initparams = join ', ', map {"$_->[0]: $_->[1]"} @initVars;
$initparams =~ s/(.\?)/$1 = nil/mg;
my $initdeclares = join "\n", map {"self.$_->[0] = $_->[0]"} @initVars;


say qq |
	 init($initparams){
	$initdeclares
}|;

