#!perl -w
use strict;
use Test::More;
use WWW::Mechanize::Firefox;

my $mech = eval { WWW::Mechanize::Firefox->new( 
    autodie => 0,
    #log => [qw[debug]]
)};

if (! $mech) {
    my $err = $@;
    plan skip_all => "Couldn't connect to MozRepl: $@";
    exit
} else {
    plan tests => 2;
};

$mech->get_local("52-frameset.html");

my @frames = map { $mech->content( document => $_ ) }
    $mech->expand_frames('frame[name="myframe1"]');
is @frames, 1, "We found the one specified frame";
like $frames[0], qr{\Q<div id="content">52-subframe.html</div>}, "We found the right subframe";