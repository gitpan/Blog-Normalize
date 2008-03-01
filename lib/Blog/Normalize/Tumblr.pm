#!/usr/bin/perl

=head1 NAME

Blog::Normalize::Tumblr - Blog::Normalize module for interaction on Tumblr

=head1 SYNOPSIS

 my $tumblr = Blog::Normalize::Tumblr->new(
 	email => 'foo@bar.com',
 	password => 'my super password',
 );
 
 $tumblr->connect;
 
 $tumblr->import(posts => $other_BN_obj->posts);

=head1 DESCRIPTION

This a module for interacting with Tumblr on the Blog::Normalize model.
Currently, this module works using C<WWW::Mechanize> to connect and 
perform the introduction of posts. The C<email> and C<password> required
by the constructor are the Tumblr login information.

=head1 TODO

=over

=item *

A lot.

=item *

Only C<connect()> and C<import()> are present.

=item *

Make C<posts()>.

=item *

Make categories to tags, etc, etc.

=back

=head1 AUTHOR

David Moreno Garza, E<lt>damogar@gmail.comE<gt> - L<http://damog.net/>

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


package Blog::Normalize::Tumblr;

our $VERSION = '0.1';

use Carp;
use Data::Dumper;
use WWW::Mechanize;

use strict;
use warnings;

sub new{
	my($self, %opts) = @_;
	
	my $opts = \%opts; 
	
	return bless {
		email 	=> $opts->{email} || 'doña juanita',
		password 	=> $opts->{password} || 'PA$$WORD',
	}, $self;
}

sub connect {
	my($self) = shift;
	
	$self->{mech} = WWW::Mechanize->new();
	
	eval {
		$self->{mech}->get('http://www.tumblr.com/login');
	};
	
	croak "Couldn't get Tumblr's login page: $@" if $@;
	
	$self->{mech}->form_number(1) or
		croak "Couldn't select the first form to login on Tumblr's login";
	
	$self->{mech}->field('email', $self->{email});
	$self->{mech}->field('password', $self->{password});
	
	$self->{mech}->submit;
	
	unless($self->{mech}->content =~ /Logging in/) {
		croak "Wrong username or password for Tumblr login\n".
		" (you provided: $self->{email} and $self->{password})\n";
	} else {
		$self->{mech}->get('http://www.tumblr.com/dashboard');
		return $self;
	}	
	
}


sub import {
	my($self, %opts) = @_;
	
	foreach my $post(@{$opts{posts}}) {
		$self->{mech}->get('http://www.tumblr.com/new/text');
		
		$self->{mech}->form_number(1) or
			croak "Couldn't select the first form of the Tumblr's post";
		
		eval {
			$self->{mech}->field('is_rich_text[one]', 0);
			$self->{mech}->field('is_rich_text[two]', 1);
			$self->{mech}->field('is_rich_text[three]', 0);
			$self->{mech}->field('post[one]', $post->{title});
			$self->{mech}->field('post[two]', $post->{text});
			$self->{mech}->field('post[is_private]', 0);
			$self->{mech}->field('post[date]', $post->{date});
			$self->{mech}->field('post[tags]', 'comma, separated, tags');
			$self->{mech}->field('post[type]', 'regular');
		};
		
		croak "Issues while setting fields for post: $@" if $@;
		
		$self->{mech}->submit;
		
		# We should do some sort of testing here
		
		sleep 1;
	}
	
}

1;