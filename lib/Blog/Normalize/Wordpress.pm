#!/usr/bin/perl

package Blog::Normalize::Wordpress;

our $VERSION = '0.0rc1';

use strict;
use warnings;

use Data::Dumper;
use DBI;

sub new{
	my($self, %opts) = @_;
	
	my $opts = \%opts; 
	
	return bless {
		database => $opts->{database} || 'myDB',
		username => $opts->{username} || 'doña juanita',
		password => $opts->{password} || 'PA$$WORD',
		hostname => $opts->{hostname} || 'localhost',
		prefix => $opts->{prefix} || 'wp_',
		port => $opts->{port} || 3306,
	}, $self;
}

sub connect {
	my($self) = shift;
	
	my $dsn = qq{DBI:mysql:database=$self->{database};host=$self->{hostname};port=$self->{port};};

    $self->{dbh} = DBI->connect($dsn, $self->{username}, $self->{password}, { RaiseError => 1 });
    
    return $self;
}

sub posts {
	my($self) = shift;
	
	my $sth = $self->{dbh}->prepare(qq{
		SELECT ID, post_date, post_content, post_title, post_category, post_name
		FROM $self->{prefix}posts
		ORDER BY post_date
	});
	
	$sth->execute;
	
	my $ret;
	
	while(my $ref = $sth->fetchrow_hashref) {
		push @{$ret}, { 
			id => $ref->{ID},
			title => $ref->{post_title},
			date => $ref->{post_date},
			category => $ref->{post_category},
			text => $ref->{post_content},
			name => $ref->{post_name},
		},
	}

	return $ret;
	
}

1;