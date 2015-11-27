#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/lib";

use File::Temp;
use IO::File;
use IO::Handle;

use Test::More;
use Test::Sources;
use Test::Warnings;

require "$FindBin::Bin/../bin/yaml2po";	## no critic(RequireBarewordIncludes)

# This is POSIXy and works with most shells.
my $gettext = qx{sh -c 'command -v gettext'};

chomp $gettext;
if (!-x $gettext) {
	plan skip_all => 'No gettext found';
}

my @sources = Test::Sources::yaml_files();

plan tests => @sources + 1;

my $devnull = IO::File->new('/dev/null', 'w');

foreach my $file (@sources) {
	my $temp = File::Temp->new;
	my $dir = $temp->newdir;
	my $dest = "$dir/file.po";
	my $tfh = IO::File->new($dest, "w");

	my $fh = IO::File->new($file, 'r');
	$tfh->print(App::yaml2po::process($fh));

	my $ret;
	{
		local *STDOUT = \*STDOUT;
		local *STDERR = \*STDERR;
		STDOUT->fdopen($devnull, 'w');
		STDERR->fdopen($devnull, 'w');
		$ret = system($gettext, $dest);
	}
	is($ret, 0, "gettext processed $file successfully");
}
