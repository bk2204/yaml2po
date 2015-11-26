#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/lib";

use IO::File;
use IO::Scalar;

use Test::Differences;
use Test::More;
use Test::Sources;
use Test::Warnings;

require "$FindBin::Bin/../bin/yaml2po";	## no critic(RequireBarewordIncludes)
require "$FindBin::Bin/../bin/po2yaml";	## no critic(RequireBarewordIncludes)

my @sources = Test::Sources::yaml_files();

plan tests => @sources + 1;

foreach my $file (@sources) {
	my $fh = IO::File->new($file, 'r');
	my $source = do { local $/; $fh->getline };
	my $po = App::yaml2po::process(IO::Scalar->new(\$source));
	my $yaml = App::po2yaml::process(IO::Scalar->new(\$po));

	eq_or_diff($source, $yaml, "File $file round-trips properly");
}
