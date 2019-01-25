#!/usr/bin/perl -CS

#generates a summary of the encoding.
#see
#https://en.wikipedia.org/wiki/Braille_ASCII

# "Unicode includes a means for encoding eight-dot Braille; however, Braille ASCII continues to be the preferred format for encoding six-dot Braille."


use v5.12;
use utf8;
use LWP::Simple;
use Data::Dumper;
use Getopt::Long;
use lib qw(.);
use H2BEncoder;# qw(braille2BrailleAscii heb2BrailleUnicode); 
use common::sense;

use charnames ();

my $tEncoding ='CP';
my $dageshMode ='HEH_BGDCFT';
GetOptions(
	   "taammim-encoding|e=s" => \$tEncoding,
    "dagesh-mode|m=s" => \$dageshMode,

	   );



my $enc = H2BEncoder->new(mode => $tEncoding, dageshMode => $dageshMode);



say <<EOF;
<!html>
<html>
    <head>
	<meta  charset="UTF-8">
	<style>
	 td {vertical-align:top;}
         td.heb {direction:rtl; unicode-bidi:bidi-override;}
td.braille {  background:lightgrey; }
td.braille span {  background:white; }
	</style>
    </head>
    <body>

    <table>
    
	<th>Unicode Name<th>Hebrew<th>Braille

EOF

    my $basic = $enc->basicData;
    my $basicTests = $enc->additionalBasicTests;
    
    for my $struct (@$basic, @$basicTests, @{$enc->getTaamData()}){
	my $char = $struct->{src};
	my $note = $struct->{note};
	if( !$char){
	    say qq(<tr><td colspan=2"><hr> $note);
	    next;
	}

	my $name = oduni($char);

	my $text = "\N{HEBREW LETTER BET}$char";
	my $uni  = $enc->heb2BrUni($text,highlightTaamim => 1);
	my $accessible = $enc->brUni2Accessible($uni);
	say "<tr><td>$name<td>$text<td class='braille'>$uni</td><td class='acc'>$accessible</td><td>$note</td></tr>";
}
say "</table>";

exit 0;

#returns ($name, $hex) 
# or just $name in a scalar context
sub oduni{
    my $str = shift;
    my (@names, @hexes);
    for (my $i =0; $i< length($str);$i++)
    {
        my $char = substr($str,$i,1);
        my $pchar = $char;
        my $hex = sprintf('[0x%x]',ord($char));
        if( $char =~ /\p{Z}|\p{C}/ )
        {
            $pchar = $hex;
        }
        my $name = charnames::viacode(ord($char));
	push @hexes, $hex;
	push @names, $name;
    }
    my $name = join ",",@names;
    my $hexes = join ",",@hexes;
    if( wantarray){
	return ($name, $hexes);
    }
    return $name;
    
}
