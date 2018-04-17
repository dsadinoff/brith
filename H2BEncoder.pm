package H2BEncoder;

use utf8;
use common::sense;
use Moo;
use Method::Signatures;

method brUni2BrAscii($input){
    $input =~ tr{⠁⠂⠃⠄⠅⠆⠇⠈⠉⠊⠋⠌⠍⠎⠏⠐⠑⠒⠓⠔⠕⠖⠗⠘⠙⠚⠛⠜⠝⠞⠟⠠⠡⠢⠣⠤⠥⠦⠧⠨⠩⠪⠫⠬⠭⠮⠯⠰⠱⠲⠳⠴⠵⠶⠷⠸⠹⠺⠻⠼⠽⠾⠿⠀}{A1B'K2L@CIF/MSP"E3H9O6R^DJG>NTQ,*5<\-U8V.%[$+X!&;:4\\0Z7(_?W]#Y)=};
    return $input;
}

# convert hebrew to unicode Braille
method heb2BrUni($string, :$highlightTaamim) {
    my @precomposed = (
	{ pat => qr"\N{HEBREW LETTER BET}\N{HEBREW POINT DAGESH OR MAPIQ}" , repl => "\N{BRAILLE PATTERN DOTS-12}"},

	{ pat => qr"\N{HEBREW LETTER VAV}\N{HEBREW POINT DAGESH OR MAPIQ}",repl => "\N{BRAILLE PATTERN DOTS-346}"}, # שורוק
	{ pat => qr"\N{HEBREW LETTER VAV WITH DAGESH}",repl => "\N{BRAILLE PATTERN DOTS-346}"}, #

	{ pat => qr"\N{HEBREW LETTER KAF}\N{HEBREW POINT DAGESH OR MAPIQ}",repl => "\N{BRAILLE PATTERN DOTS-13}"},
	{ pat => qr"\N{HEBREW LETTER FINAL KAF}\N{HEBREW POINT DAGESH OR MAPIQ}",repl => "\N{BRAILLE PATTERN DOTS-13}"},

	{ pat => qr"\N{HEBREW LETTER PE}\N{HEBREW POINT DAGESH OR MAPIQ}",repl => "\N{BRAILLE PATTERN DOTS-1234}"},
	{ pat => qr"\N{HEBREW LETTER FINAL PE}\N{HEBREW POINT DAGESH OR MAPIQ}",repl => "\N{BRAILLE PATTERN DOTS-1234}"},

	{ pat => qr"\N{HEBREW LETTER SHIN}\N{HEBREW POINT SHIN DOT}",repl => "\N{BRAILLE PATTERN DOTS-146}"},
	{ pat => qr"\N{HEBREW LETTER SHIN}\N{HEBREW POINT SIN DOT}",repl => "\N{BRAILLE PATTERN DOTS-156}"},


	{ pat => qr"\N{HEBREW LETTER TAV}\N{HEBREW POINT DAGESH OR MAPIQ}",repl => "\N{BRAILLE PATTERN DOTS-1256}"},


	# unification to regular punctuation
	{ pat => qr"\N{HEBREW PUNCTUATION MAQAF}",repl => "-"},
	{ pat => qr"\N{HEBREW PUNCTUATION SOF PASUQ}",repl => "."},
	
	);

    for  my $struct (@precomposed){
	my $pat = $struct->{pat};
	my $repl = $struct->{repl};
	$string =~ s{$pat}{$repl}g;
    }
    

    # Inspired by UEB 15.3 "Tone". Arguably the introduction ought to be two symbols instead of one in order not to conflict with UEB15.3
    # http://www.iceb.org/Rules%20of%20Unified%20English%20Braille%202013%20(linked).pdf
    my $taamAbove = "\N{BRAILLE PATTERN DOTS-45}";
    my $taamBelow = "\N{BRAILLE PATTERN DOTS-56}";
    my $colonBraille= "\N{BRAILLE PATTERN DOTS-25}"; # can't use a colon, it's the same symbols as hataf-patach
    my $periodBraille= "\N{BRAILLE PATTERN DOTS-256}";
    my $hyphenMinusBraille= "\N{BRAILLE PATTERN DOTS-36}";
    
    my %map =(
	"א" => "\N{BRAILLE PATTERN DOTS-1}",
	"ב" => "\N{BRAILLE PATTERN DOTS-1236}",
	"ג" => "\N{BRAILLE PATTERN DOTS-1245}",
	"ד" => "\N{BRAILLE PATTERN DOTS-145}",
	"ה" => "\N{BRAILLE PATTERN DOTS-125}",

	"ו" => "\N{BRAILLE PATTERN DOTS-2456}",

	
	"ז" => "\N{BRAILLE PATTERN DOTS-1356}",
	"ח" => "\N{BRAILLE PATTERN DOTS-1346}",
	"ט" => "\N{BRAILLE PATTERN DOTS-2345}",
	"י" => "\N{BRAILLE PATTERN DOTS-245}",
	"כ" => "\N{BRAILLE PATTERN DOTS-16}",
	"ך" => "\N{BRAILLE PATTERN DOTS-16}",

	"ל" => "\N{BRAILLE PATTERN DOTS-123}",
	"מ" => "\N{BRAILLE PATTERN DOTS-134}",
	"ם" => "\N{BRAILLE PATTERN DOTS-134}",


	"נ" => "\N{BRAILLE PATTERN DOTS-1345}",
	"ן" => "\N{BRAILLE PATTERN DOTS-1345}",

	"ס" => "\N{BRAILLE PATTERN DOTS-234}",
	"ע" => "\N{BRAILLE PATTERN DOTS-1246}",

	"פ" => "\N{BRAILLE PATTERN DOTS-124}",
	"ף" => "\N{BRAILLE PATTERN DOTS-124}",
	
	"צ" => "\N{BRAILLE PATTERN DOTS-2346}",
	"ץ" => "\N{BRAILLE PATTERN DOTS-2346}",
	
	"ק" => "\N{BRAILLE PATTERN DOTS-12345}",
	"ר" => "\N{BRAILLE PATTERN DOTS-1235}",

	"ש" => "\N{BRAILLE PATTERN DOTS-146}",
	"שׁ" => "\N{BRAILLE PATTERN DOTS-146}",
	"שׂ" => "\N{BRAILLE PATTERN DOTS-156}",

	"ת" => "\N{BRAILLE PATTERN DOTS-1456}",


	"-" => $hyphenMinusBraille,
	"." => $periodBraille,

	"\N{HEBREW POINT HIRIQ}" => "\N{BRAILLE PATTERN DOTS-24}",
	"\N{HEBREW POINT TSERE}" => "\N{BRAILLE PATTERN DOTS-34}",
	"\N{HEBREW POINT SEGOL}" => "\N{BRAILLE PATTERN DOTS-15}",
	"\N{HEBREW POINT PATAH}" => "\N{BRAILLE PATTERN DOTS-14}",
	"\N{HEBREW POINT QAMATS}" => "\N{BRAILLE PATTERN DOTS-126}",
	"\N{HEBREW POINT HOLAM}" => "\N{BRAILLE PATTERN DOTS-246}",
	"\N{HEBREW POINT QUBUTS}" => "\N{BRAILLE PATTERN DOTS-136}",
	

	"\N{HEBREW POINT SHEVA}" => "\N{BRAILLE PATTERN DOTS-6}",
	"\N{HEBREW POINT HATAF SEGOL}" => "\N{BRAILLE PATTERN DOTS-26}",
	"\N{HEBREW POINT HATAF PATAH}" => "\N{BRAILLE PATTERN DOTS-25}",
	"\N{HEBREW POINT HATAF QAMATS}" => "\N{BRAILLE PATTERN DOTS-345}",




	# NOVEL ENCODINGS HERE

	# Need to encode: 32 symbols.

	# 
	"\N{HEBREW POINT DAGESH OR MAPIQ}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1245}",


	# below
	#prefixed with "caps" dots-6
	"\N{HEBREW ACCENT MERKHA}" => "$taamBelow\N{BRAILLE PATTERN DOTS-23}",
	"\N{HEBREW ACCENT TIPEHA}" => "$taamBelow\N{BRAILLE PATTERN DOTS-14}",
	"\N{HEBREW ACCENT MERKHA KEFULA}" => "$taamBelow\N{BRAILLE PATTERN DOTS-2345}",
	"\N{HEBREW ACCENT ETNAHTA}" => "$taamBelow\N{BRAILLE PATTERN DOTS-2}",
	"\N{HEBREW ACCENT YERAH BEN YOMO}" => "$taamBelow\N{BRAILLE PATTERN DOTS-13456}",
	"\N{HEBREW ACCENT ATNAH HAFUKH}" => "$taamBelow\N{BRAILLE PATTERN DOTS-13456}", # aka Yerech ben yomo
	"\N{HEBREW ACCENT TEVIR}" => "$taamBelow\N{BRAILLE PATTERN DOTS-1245}",
	"\N{HEBREW ACCENT YETIV}" => "$taamBelow\N{BRAILLE PATTERN DOTS-246}",
	"\N{HEBREW ACCENT MUNAH}" => "$taamBelow\N{BRAILLE PATTERN DOTS-356}",
	"\N{HEBREW ACCENT MAHAPAKH}" => "$taamBelow\N{BRAILLE PATTERN DOTS-145}",

	# not a taam-ACCENT But belongs on the bottom.
	"\N{HEBREW POINT METEG}" => "$taamBelow\N{BRAILLE PATTERN DOTS-12}",
	

	# above
	#prefixed with "up-top" dots-3
	"\N{HEBREW ACCENT SEGOL}" => "$taamAbove\N{BRAILLE PATTERN DOTS-15}", # cf HEBREW POINT SEGOL
	"\N{HEBREW ACCENT SHALSHELET}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1356}",
	"\N{HEBREW ACCENT ZAQEF QATAN}" => "$taamAbove\N{BRAILLE PATTERN DOTS-13}",
	"\N{HEBREW ACCENT ZAQEF GADOL}" => "$taamAbove\N{BRAILLE PATTERN DOTS-12346}",
	"\N{HEBREW ACCENT ZINOR}" => "$taamAbove\N{BRAILLE PATTERN DOTS-12345}", # misnamed zarqa.  consider zayin instead?
	"\N{HEBREW ACCENT PASHTA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-245}",
	"\N{HEBREW ACCENT GERESH}" => "$taamAbove\N{BRAILLE PATTERN DOTS-12}",
	"\N{HEBREW ACCENT GERESH MUQDAM}" => "$taamAbove\N{BRAILLE PATTERN DOTS-12}", # unified with geresh
	"\N{HEBREW ACCENT GERSHAYIM}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1256}",
	"\N{HEBREW ACCENT REVIA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1235}",
	"\N{HEBREW ACCENT QARNEY PARA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1346}",

	"\N{HEBREW ACCENT PAZER}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1236}",
	"\N{HEBREW ACCENT DARGA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-135}",
	"\N{HEBREW ACCENT QADMA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-124}",

	"\N{HEBREW ACCENT TELISHA GEDOLA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1345}",
	"\N{HEBREW ACCENT TELISHA QETANA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1246}",
	
	# only in אמ"ת.  For completeness
	"\N{HEBREW ACCENT OLE}" => "\N{BRAILLE PATTERN DOTS-12345678}",
	"\N{HEBREW ACCENT ILUY}" => "\N{BRAILLE PATTERN DOTS-12345678}",
	"\N{HEBREW ACCENT DEHI}" => "\N{BRAILLE PATTERN DOTS-12345678}",
	"\N{HEBREW ACCENT ZARQA}" => "\N{BRAILLE PATTERN DOTS-12345678}", # actually a Tzinor
	
	" " => "\N{BRAILLE PATTERN BLANK}"

	);
    my @chars = split //, $string;
    # say Dumper(\@chars);
    my $brailleUnicode =  join "", map { $map{$_} || $_ } @chars;
    if( $highlightTaamim){
	my $brailleHTML = $brailleUnicode;
	$brailleHTML =~ s{(($taamAbove|$taamBelow).)}{<span class="taam">$1</span>}g;
	$brailleHTML =~ s{([$periodBraille$hyphenMinusBraille])}{<span class="punct">$1</span>}g;
	return $brailleHTML;
    }
    else{
	return $brailleUnicode;
    }
}

1;
