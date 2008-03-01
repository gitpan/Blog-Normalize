#!/usr/bin/perl

die "use this script not to run it, but for see the source";

use lib '../lib';

use Blog::Normalize::MovableType;
use Blog::Normalize::Tumblr;

my $tr = Blog::Normalize::Tumblr->new(
	email => 'damogar@gmail.com',
	password => q?hackme?,
);

my $mt = Blog::Normalize::MovableType->new(
	username => 'damog_mt',
	password => 'damog_mt',
);

$mt->connect;
$tr->connect;

$tr->import(posts => $mt->posts);