#!/usr/bin/perl

package Blog::Normalize::MovableType;

our $VERSION = '0.0rc1';

use strict;
use warnings;

use DateTime;
use Data::Dumper;
use DBI;

sub new{
	my($self, %opts) = @_;
	
	my $opts = \%opts; 
	
	return bless {
		database 	=> $opts->{database} || 'myDB',
		username 	=> $opts->{username} || 'doña juanita',
		password 	=> $opts->{password} || 'PA$$WORD',
		hostname 	=> $opts->{hostname} || 'localhost',
		prefix 		=> $opts->{prefix} || 'mt_',
		port 		=> $opts->{port} || 3306,
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
		SELECT entry_id, entry_basename, entry_authored_on, entry_title, entry_text, entry_category_id
		FROM $self->{prefix}entry
		ORDER BY entry_authored_on
	});
	
	$sth->execute;
	
	my $ret;
	
	while(my $ref = $sth->fetchrow_hashref) {
		push @{$ret}, { 
			id => $ref->{entry_id},
			title => $ref->{entry_title},
			date => $ref->{entry_authored_on},
			category => $ref->{entry_category_id},
			text => $ref->{entry_text},
			name => $ref->{entry_basename},
		},
	}

	return $ret;
	
}

sub import {
	my($self, %opts) = @_;
	
	foreach my $post(@{$opts{posts}}) {
		$self->{dbh}->do(qq{
			INSERT INTO $self->{prefix}entry (
				entry_allow_comments,
				entry_allow_pings,
				entry_atom_id,
				entry_author_id,
				entry_authored_on,
				entry_basename,
				entry_blog_id,
				entry_category_id,
				entry_class,
				entry_convert_breaks,
				entry_created_by,
				entry_created_on,
				entry_excerpt,
				entry_keywords,
				entry_meta,
				entry_modified_by,
				entry_modified_on,
				entry_pinged_urls,
				entry_status,
				entry_tangent_cache,
				entry_template_id,
				entry_text,
				entry_text_more,
				entry_title,
				entry_to_ping_urls,
				entry_week_number
			) VALUES (
				'1',
				'1',
				NULL,
				'1',
				?,
				?,
				'1',
				NULL,
				'entry',
				'richtext',
				'1',
				?,
				'',
				'',
				NULL,
				NULL,
				?,
				NULL,
				'2',
				NULL,
				NULL,
				?,
				'',
				?,
				'',
				?)}, undef,
				$post->{date},
				$post->{name},
				$post->{date},
				$post->{date},
				$post->{text},
				$post->{title},
				getYearWeek($post->{date}));
	}
}

sub getYearWeek{
	my($time) = shift;
	my($Y, $M, $D, $h, $m, $s) = $time =~ /\A(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2}):(\d{2})\z/;
	
	my $dt = DateTime->new(
		year   => $Y,
		month  => $M,
		day    => $D,
		hour   => $h,
		minute => $m,
		second => $s,
	);
	return $dt->strftime("%Y%V")
} 

1;