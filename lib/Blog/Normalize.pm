#!/usr/bin/perl

package Blog::Normalize;

use strict;
use warnings;

our $VERSION = '0.0rc2';

=head1 NAME

Blog::Normalize - Specification for a sane transition between different blogging systems

=head1 SYNOPSIS

 use Blog::Normalize::Wordpress;
 use Blog::Normalize::MovableType;
 
 # You've got to create the B::N objects with the database info:
 
 my $wp = Blog::Normalize::Wordpress->new(
	username => $username,
	password => $password,
	hostname => $hostname,
	database => $database,
	prefix => $prefix,
 );
 
 my $mt = Blog::Normalize::MovableType->new(
	username => $username,
	password => $password,
	hostname => $hostname,
	database => $database,
 );
 
 $wp->connect;
 $mt->connect;
 
 # As simple as:
 $mt->import(posts => $wp->posts);

=head1 INTRODUCTION

I needed to convert a Wordpress blog to a MovableType one. Since I didn't
find anything useful quickly on the web, I developed my own converter.
Then I realized some other people could use it and some other ones could
actually want it in the oppposite way. Then I thought on people trying to
make the same on different blog systems. I've changed from one blog to
another several times since I started my own (L<http://blog.damog.net/>)
in 2002 and it's been always a pain in the ass make converters. Hereby,
I propose the Blog::Normalize module that could import and export all sorts
of data from one blogging system to another, as long as they are supported
which should be too hard for me (or everybody else, to do).

=head1 DESCRIPTION

Objects represent a blog system. They are initialized with the needed
information (like the DB info) and ready to get data, import and export.
Posts, categories, users, everything should be able to be exported and
imported if the common spec is followed.

=head1 SPECIFICATION

=head2 POSTS

The posts should be an array reference containing, as each of the elements,
a hash reference containing each of the posts. As the time of writing, the
values C<id>, C<title>, C<date>, C<text>, C<name> should be passed.

This illustrates the idea:

 my $posts = [
 	{
 		id => 2,
 		title => 'This post is awesome!',
 		text => 'This is my second post on my blog. Welcome to it!',
 		date => '2008-02-23 21:02:52',
 		name => 'this-post-is-awesome',
 	},
 	{
 		id => 1,
 		title => 'Hit by a taxi',
 		text => 'Today, after leaving the office, I was hit by a taxi
 			in New York City. I'm just fine but it was a shocking moment.',
 		date => '2008-01-06 18:51:00',
 		name => 'hit-by-a-taxi',
 	},
 ];

=head3 id

The C<id> is usually just the idea for each of the posts, you may use
the permalink here too.

=head3 title

The title of the post entry.

=head3 text

The extended entry of the post.

=head3 date

A C<YYYY-MM-DD mm:hh:ss> formated time. 

=head3 name

A short string for identifying the post.

=head1 BUGS

Nearly everything is broken :) The only thing that barely works right
now is the import from Wordpress to MovableType, but more work is being
done. I strongly support on the c<Release Early, Release Often> motto.

=head1 TODO

=over

=item *

A LOT. ;)

=item *

Start the implementation of TextMotion.

=item *

Start the implementation of Blogger which won't use DBI but web scrapping.

=item *

Allow a DBI object on the constructor of the networks so we don't have to.

=item *

Specification for categories, user and different blogs within a same
blogging system.

=back

=head1 DISCLAIMER

This may be taken as an specification for blogging systems, but I don't
want the application to be too ambitious, so if you like the idea, it's
great! Otherwise, if you think I'm reinventing the wheel or doing something
that I shouldn't be doing, beat it. As Andy Lester commented on a Perlbuzz
column, let new projects and ideas flow!

I do think it's nice to allow developers to make great things quickly,
effectively and leaving all hard tasks to the backend through an easy
spec.

=head1 AUTHOR

David Moreno Garza, E<lt>damogar@gmail.com<gt> - L<http://damog.net/>

=head1 THANKS

To Raquel (L<http://www.maggit.com.mx/>), who makes me happy every single
day of my life.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by David Moreno Garza

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

The Do What The Fuck You Want To public license also applies. It's
really up to you.

=cut

1;