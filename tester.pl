#!/home/ccsoft/perls/cm/perl -CS


#see
#https://en.wikipedia.org/wiki/Braille_ASCII

# "Unicode includes a means for encoding eight-dot Braille; however, Braille ASCII continues to be the preferred format for encoding six-dot Braille."


use v5.12;
use utf8;
use LWP::Simple;
use Data::Dumper;
use Getopt::Long;
use lib qw(.);
use H2BEncoder qw(braille2BrailleAscii heb2BrailleUnicode); 
use common::sense;

use charnames ();


my @toTest =(
    	"\N{HEBREW POINT DAGESH OR MAPIQ}" ,


	# below
	#prefixed with "caps" dots-6
	"\N{HEBREW ACCENT MERKHA}" ,
	"\N{HEBREW ACCENT TIPEHA}" ,
	"\N{HEBREW ACCENT MERKHA KEFULA}" ,
	"\N{HEBREW ACCENT ETNAHTA}" ,
	"\N{HEBREW ACCENT YERAH BEN YOMO}" ,
	"\N{HEBREW ACCENT ATNAH HAFUKH}" ,
	"\N{HEBREW ACCENT TEVIR}" ,
	"\N{HEBREW ACCENT YETIV}" ,
	"\N{HEBREW ACCENT MUNAH}" ,
	"\N{HEBREW ACCENT MAHAPAKH}" ,

	# not a taam-ACCENT But belongs on the bottom.
	"\N{HEBREW POINT METEG}" ,

    "--",

	# above
	#prefixed with "up-top" dots-3
	"\N{HEBREW ACCENT SEGOL}" ,
	"\N{HEBREW ACCENT SHALSHELET}" ,
	"\N{HEBREW ACCENT ZAQEF QATAN}" ,
	"\N{HEBREW ACCENT ZAQEF GADOL}" ,
	"\N{HEBREW ACCENT ZINOR}" ,
	"\N{HEBREW ACCENT PASHTA}" ,
	"\N{HEBREW ACCENT GERESH}" ,
	"\N{HEBREW ACCENT GERESH MUQDAM}" ,
	"\N{HEBREW ACCENT GERSHAYIM}" ,
	"\N{HEBREW ACCENT REVIA}" ,
	"\N{HEBREW ACCENT QARNEY PARA}" ,

	"\N{HEBREW ACCENT PAZER}" ,
	"\N{HEBREW ACCENT DARGA}" ,
	"\N{HEBREW ACCENT QADMA}" ,

	"\N{HEBREW ACCENT TELISHA GEDOLA}" ,
	"\N{HEBREW ACCENT TELISHA QETANA}" ,

    "--",
	
	# only in אמ"ת.  For completeness
	"\N{HEBREW ACCENT OLE}" ,
	"\N{HEBREW ACCENT ILUY}" ,
	"\N{HEBREW ACCENT DEHI}" ,
    "\N{HEBREW ACCENT ZARQA}" ,
    );

say <<EOF;
<!html>
<html>
    <head>
	<meta  charset="UTF-8">
	<style>
	 td {vertical-align:top;}
	 td.heb {direction:rtl; unicode-bidi:bidi-override;}
	</style>
    </head>
    <body>

    <table>
    
	<th>taam<th>Braille

EOF

    
    for my $char (@toTest){
	if( $char eq'--'){
	    say qq(<tr><td colspan=2"><hr>);
	}
	my $name = charnames::viacode(ord($char));
	my $uni  = heb2BrailleUnicode($char);
	say "<tr><td>$name<td>$uni</td></tr>";
}
say "</table>";

exit 0;
