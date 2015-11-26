package Test::Sources;

use strict;
use warnings;

use FindBin;

sub yaml_files {
	my $yaml_dir_path = "$FindBin::Bin/support/yaml";

	opendir(my $dh, $yaml_dir_path) or return;
	my @dirs = grep { !/^\./ && -d } map { "$yaml_dir_path/$_" } readdir $dh;
	closedir($dh);

	my @yaml;
	foreach my $dir (@dirs) {
		opendir(my $dh, $dir) or next;
		push @yaml, grep { /\.yaml$/ && -f } map { "$dir/$_" } readdir $dh;
		closedir($dh);
	}
	@yaml = sort @yaml;
	return @yaml;
}

1;
