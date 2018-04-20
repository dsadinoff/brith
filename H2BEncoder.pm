package H2BEncoder;

use utf8;
use common::sense;
use Moo;
use Method::Signatures;

use namespace::clean;

has mode => (
    is => 'ro',
    default => 'CO',
    );


method brUni2BrAscii($input){
    $input =~ tr{⠁⠂⠃⠄⠅⠆⠇⠈⠉⠊⠋⠌⠍⠎⠏⠐⠑⠒⠓⠔⠕⠖⠗⠘⠙⠚⠛⠜⠝⠞⠟⠠⠡⠢⠣⠤⠥⠦⠧⠨⠩⠪⠫⠬⠭⠮⠯⠰⠱⠲⠳⠴⠵⠶⠷⠸⠹⠺⠻⠼⠽⠾⠿⠀}{A1B'K2L@CIF/MSP"E3H9O6R^DJG>NTQ,*5<\-U8V.%[$+X!&;:4\\0Z7(_?W]#Y)=};
    return $input;
}

method toMap($dataAref){
    my %map = (map {if( $_->{src}){ ($_->{src} => $_->{target})}else{()}} @$dataAref);
    return %map
}


method basicData{
    return [
{ src=>"א"  , target=> "\N{BRAILLE PATTERN DOTS-1}"},
{ src=>"ב"  , target=> "\N{BRAILLE PATTERN DOTS-1236}"},
{ src=>"ג"  , target=> "\N{BRAILLE PATTERN DOTS-1245}"},
{ src=>"ד"  , target=> "\N{BRAILLE PATTERN DOTS-145}"},
{ src=>"ה"  , target=> "\N{BRAILLE PATTERN DOTS-125}"},

{ src=>"ו"  , target=> "\N{BRAILLE PATTERN DOTS-2456}"},

	
{ src=>"ז"  , target=> "\N{BRAILLE PATTERN DOTS-1356}"},
{ src=>"ח"  , target=> "\N{BRAILLE PATTERN DOTS-1346}"},
{ src=>"ט"  , target=> "\N{BRAILLE PATTERN DOTS-2345}"},
{ src=>"י"  , target=> "\N{BRAILLE PATTERN DOTS-245}"},
{ src=>"כ"  , target=> "\N{BRAILLE PATTERN DOTS-16}"},
{ src=>"ך"  , target=> "\N{BRAILLE PATTERN DOTS-16}"},

{ src=>"ל"  , target=> "\N{BRAILLE PATTERN DOTS-123}"},
{ src=>"מ"  , target=> "\N{BRAILLE PATTERN DOTS-134}"},
{ src=>"ם"  , target=> "\N{BRAILLE PATTERN DOTS-134}"},


{ src=>"נ"  , target=> "\N{BRAILLE PATTERN DOTS-1345}"},
{ src=>"ן"  , target=> "\N{BRAILLE PATTERN DOTS-1345}"},

{ src=>"ס"  , target=> "\N{BRAILLE PATTERN DOTS-234}"},
{ src=>"ע"  , target=> "\N{BRAILLE PATTERN DOTS-1246}"},

{ src=>"פ"  , target=> "\N{BRAILLE PATTERN DOTS-124}"},
{ src=>"ף"  , target=> "\N{BRAILLE PATTERN DOTS-124}"},
	
{ src=>"צ"  , target=> "\N{BRAILLE PATTERN DOTS-2346}"},
{ src=>"ץ"  , target=> "\N{BRAILLE PATTERN DOTS-2346}"},
	
{ src=>"ק"  , target=> "\N{BRAILLE PATTERN DOTS-12345}"},
{ src=>"ר"  , target=> "\N{BRAILLE PATTERN DOTS-1235}"},

{ src=>"ש"  , target=> "\N{BRAILLE PATTERN DOTS-146}"},
{ src=>"שׁ"  , target=> "\N{BRAILLE PATTERN DOTS-146}"},
{ src=>"שׂ"  , target=> "\N{BRAILLE PATTERN DOTS-156}"},

{ src=>"ת"  , target=> "\N{BRAILLE PATTERN DOTS-1456}"},


{ src=>"\N{HEBREW POINT HIRIQ}"  , target=> "\N{BRAILLE PATTERN DOTS-24}"},
{ src=>"\N{HEBREW POINT TSERE}"  , target=> "\N{BRAILLE PATTERN DOTS-34}"},
{ src=>"\N{HEBREW POINT SEGOL}"  , target=> "\N{BRAILLE PATTERN DOTS-15}"},
{ src=>"\N{HEBREW POINT PATAH}"  , target=> "\N{BRAILLE PATTERN DOTS-14}"},
{ src=>"\N{HEBREW POINT QAMATS}"  , target=> "\N{BRAILLE PATTERN DOTS-126}"},
{ src=>"\N{HEBREW POINT HOLAM}"  , target=> "\N{BRAILLE PATTERN DOTS-246}"},
{ src=>"\N{HEBREW POINT QUBUTS}"  , target=> "\N{BRAILLE PATTERN DOTS-136}"},
	

{ src=>"\N{HEBREW POINT SHEVA}"  , target=> "\N{BRAILLE PATTERN DOTS-6}"},
{ src=>"\N{HEBREW POINT HATAF SEGOL}"  , target=> "\N{BRAILLE PATTERN DOTS-26}"},
{ src=>"\N{HEBREW POINT HATAF PATAH}"  , target=> "\N{BRAILLE PATTERN DOTS-25}"},
{ src=>"\N{HEBREW POINT HATAF QAMATS}"  , target=> "\N{BRAILLE PATTERN DOTS-345}"},

	{ src=>" "  , target=> "\N{BRAILLE PATTERN BLANK}"},

	];
}


method getTaamData(){
    my $taamAbove = "\N{BRAILLE PATTERN DOTS-45}";
    my $taamBelow = "\N{BRAILLE PATTERN DOTS-56}";
    my $colonBraille= "\N{BRAILLE PATTERN DOTS-25}"; # can't use a colon, it's the same symbols as hataf-patach

    my $periodBraille= "\N{BRAILLE PATTERN DOTS-256}";
    my $hyphenMinusBraille= "\N{BRAILLE PATTERN DOTS-36}";

    
    for($self->mode){
	when('CP'){
	    return
		[
		 { src=>"-" , target=> $hyphenMinusBraille, note=>""},
		 { src=>"." , target=> $periodBraille, note=> ''},
		 
		 
		 # NOVEL ENCODINGS HERE
		 
		 # Need to encode: 32 symbols.
		 
		 { src=>"\N{HEBREW POINT DAGESH OR MAPIQ}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-1245}", note=>"This is a standard mentioned in the WP page for the uncoded dagesh kal for ג,ד, dagesh chazak and mapiq"}, 
		 
		 { src=>"\N{HEBREW PUNCTUATION PASEQ}" , target=> "\N{BRAILLE PATTERN DOTS-456}\N{BRAILLE PATTERN DOTS-1256}", note=>"from the english for vertical bar"},
		 
		 { note => "below"},
		 { src=>"\N{HEBREW ACCENT MERKHA}" , target=> "$taamBelow\N{BRAILLE PATTERN DOTS-23}", note=>""},
		 { src=>"\N{HEBREW ACCENT TIPEHA}" , target=> "$taamBelow\N{BRAILLE PATTERN DOTS-14}", note=>""},
		 { src=>"\N{HEBREW ACCENT MERKHA KEFULA}" , target=> "$taamBelow\N{BRAILLE PATTERN DOTS-1236}", note=>"Bet"}, 
		 { src=>"\N{HEBREW ACCENT ETNAHTA}" , target=> "$taamBelow\N{BRAILLE PATTERN DOTS-1}", note=>"Aleph"},
		 { src=>"\N{HEBREW ACCENT YERAH BEN YOMO}" , target=> "$taamBelow\N{BRAILLE PATTERN DOTS-13456}", note=>""},
		 { src=>"\N{HEBREW ACCENT ATNAH HAFUKH}" , target=> "$taamBelow\N{BRAILLE PATTERN DOTS-13456}", note=>"AKA Yerech ben Yamo"}, 
		 { src=>"\N{HEBREW ACCENT TEVIR}" , target=> "$taamBelow\N{BRAILLE PATTERN DOTS-1456}", note=>"TAF"},
		 { src=>"\N{HEBREW ACCENT YETIV}" , target=> "$taamBelow\N{BRAILLE PATTERN DOTS-245}", note=>"YOD"}, 
		 { src=>"\N{HEBREW ACCENT MUNAH}" , target=> "$taamBelow\N{BRAILLE PATTERN DOTS-134}", note=>"MEM"}, 
		 { src=>"\N{HEBREW ACCENT MAHAPAKH}" , target=> "$taamBelow\N{BRAILLE PATTERN DOTS-13}", note=>"Less than symbo"}, 
		 
		 { src=>"\N{HEBREW POINT METEG}" , target=> "$taamBelow\N{BRAILLE PATTERN DOTS-12}", note=>"taam-ACCENT But belongs on the bottom"},
		 
		 
		 { note => "below"},
		 { src=>"\N{HEBREW ACCENT SEGOL}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-234}", note=>"HEBREW POINT SEGOL  - samech"},
		 { src=>"\N{HEBREW ACCENT SHALSHELET}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-1356}", note=>""},
		 { src=>"\N{HEBREW ACCENT ZAQEF QATAN}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-125}", note=>"heh"},
		 { src=>"\N{HEBREW ACCENT ZAQEF GADOL}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-1245}", note=>"gimel"},
		 { src=>"\N{HEBREW ACCENT ZINOR}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-1356}", note=>"misnamed Zarqa.  ZAYIN"}, 
		 { src=>"\N{HEBREW ACCENT PASHTA}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-2456}", note=>"VAV"}, 
		 { src=>"\N{HEBREW ACCENT GERESH}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-123}", note=>"AKA azla.  Lamed"},
		 { src=>"\N{HEBREW ACCENT GERESH MUQDAM}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-123}", note=>"Unified with GERESH"},
		 { src=>"\N{HEBREW ACCENT GERSHAYIM}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-1345}", note=>"NUN"},
		 { src=>"\N{HEBREW ACCENT REVIA}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-1235}", note=>"RESH"}, 
		 { src=>"\N{HEBREW ACCENT QARNEY PARA}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-1346}", note=>""},
		 
		 { src=>"\N{HEBREW ACCENT PAZER}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-124}", note=>"PE"}, 
		 { src=>"\N{HEBREW ACCENT DARGA}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-145}", note=>"DALET"}, 
		 { src=>"\N{HEBREW ACCENT QADMA}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-12345}", note=>"QOF"}, 
		 
		 { src=>"\N{HEBREW ACCENT TELISHA GEDOLA}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-146}", note=>"SHIN"},
		 { src=>"\N{HEBREW ACCENT TELISHA QETANA}" , target=> "$taamAbove\N{BRAILLE PATTERN DOTS-156}", note=>"SIN"},
		 




		 { note => "only in אמ\"ת.  For completeness"},
		 
		 # 
		 { src=>"\N{HEBREW ACCENT OLE}" , target=> "\N{BRAILLE PATTERN DOTS-12345678}", note=>""},
		 { src=>"\N{HEBREW ACCENT ILUY}" , target=> "\N{BRAILLE PATTERN DOTS-12345678}", note=>""},
		 { src=>"\N{HEBREW ACCENT DEHI}" , target=> "\N{BRAILLE PATTERN DOTS-12345678}", note=>""},
		 { src=>"\N{HEBREW ACCENT ZARQA}" , target=> "\N{BRAILLE PATTERN DOTS-12345678}", note=>"Actually a tzinor"},
		 
		 { note => "not yet coded"},
		 { src=>"\N{HEBREW PUNCTUATION NUN HAFUKHA}" , target=> "\N{BRAILLE PATTERN DOTS-12345678}", note=>""},
		 
		 { src=>"\N{HEBREW MARK UPPER DOT}" , target=> "\N{BRAILLE PATTERN DOTS-12345678}", note=>""}, # 
		 { src=>"\N{HEBREW MARK LOWER DOT}" , target=> "\N{BRAILLE PATTERN DOTS-12345678}", note=>""}, # 
		 
		 { src=>"\N{HEBREW POINT QAMATS QATAN}" , target=> "\N{BRAILLE PATTERN DOTS-12345678}", note=>"unify with Qamats?"},
	
	];

	}

	
    }
}

method getBasicDataMap(){
    return $self->toMap($self->basicData);
    
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
    
    my %basicHebrew =  $self->getBasicDataMap();

    # Inspired by UEB 15.3 "Tone". Arguably the introduction ought to be two symbols instead of one in order not to conflict with UEB15.3
    # http://www.iceb.org/Rules%20of%20Unified%20English%20Braille%202013%20(linked).pdf
    my $taamAbove = "\N{BRAILLE PATTERN DOTS-45}";
    my $taamBelow = "\N{BRAILLE PATTERN DOTS-56}";
    my $colonBraille= "\N{BRAILLE PATTERN DOTS-25}"; # can't use a colon, it's the same symbols as hataf-patach

    my $periodBraille= "\N{BRAILLE PATTERN DOTS-256}";
    my $hyphenMinusBraille= "\N{BRAILLE PATTERN DOTS-36}";

    # Clarity - Orthographic
    #this encoding uses an escape character .
    my %CO = (
	"-" => $hyphenMinusBraille,
	"." => $periodBraille,
	
	
	# NOVEL ENCODINGS HERE

	# Need to encode: 32 symbols.

	# This is a standard mentioned in the WP page
	# for the uncoded dagesh kal for ג,ד, dagesh chazak and mapiq	
	"\N{HEBREW POINT DAGESH OR MAPIQ}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1245}", 

	# from the english for vertical bar
	"\N{HEBREW PUNCTUATION PASEQ}" => "\N{BRAILLE PATTERN DOTS-456}\N{BRAILLE PATTERN DOTS-1256}",


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
	"\N{HEBREW ACCENT GERESH}" => "$taamAbove\N{BRAILLE PATTERN DOTS-12}", # AKA Azla
	"\N{HEBREW ACCENT GERESH MUQDAM}" => "$taamAbove\N{BRAILLE PATTERN DOTS-12}", # unified with geresh...
	"\N{HEBREW ACCENT GERSHAYIM}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1256}",
	"\N{HEBREW ACCENT REVIA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1235}",
	"\N{HEBREW ACCENT QARNEY PARA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1346}",

	"\N{HEBREW ACCENT PAZER}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1236}",
	"\N{HEBREW ACCENT DARGA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-135}",
	"\N{HEBREW ACCENT QADMA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-124}",

	"\N{HEBREW ACCENT TELISHA GEDOLA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1345}",
	"\N{HEBREW ACCENT TELISHA QETANA}" => "$taamAbove\N{BRAILLE PATTERN DOTS-1246}",
	


	"\N{HEBREW PUNCTUATION NUN HAFUKHA}" => "\N{BRAILLE PATTERN DOTS-12345678}",

	# only in אמ"ת.  For completeness
	"\N{HEBREW ACCENT OLE}" => "\N{BRAILLE PATTERN DOTS-12345678}",
	"\N{HEBREW ACCENT ILUY}" => "\N{BRAILLE PATTERN DOTS-12345678}",
	"\N{HEBREW ACCENT DEHI}" => "\N{BRAILLE PATTERN DOTS-12345678}",
	"\N{HEBREW ACCENT ZARQA}" => "\N{BRAILLE PATTERN DOTS-12345678}", # actually a Tzinor

	# uncoded yet
	"\N{HEBREW MARK UPPER DOT}" => "\N{BRAILLE PATTERN DOTS-12345678}", # 
	"\N{HEBREW MARK LOWER DOT}" => "\N{BRAILLE PATTERN DOTS-12345678}", # 

	"\N{HEBREW POINT QAMATS QATAN}" => "\N{BRAILLE PATTERN DOTS-12345678}", # unify with Qamats?
	

	);



    # Clarity - Phonetic
    #this encoding uses an escape character
    my $cpData =$self->getTaamData();
    
    my %CP = (map {if( $_->{src}){ ($_->{src} => $_->{target})}else{()}} @$cpData);
    
    my %map;
    for ($self->mode){
	when('CO'){
	    %map = (%basicHebrew , %CO);	    
	}
	when('CP'){
	    %map = (%basicHebrew , %CP);
	}
	default{
	    die "unknown encode mode $_";
	}
    }

    my @chars = split //, $string;
    # say Dumper(\@chars);
    my $brailleUnicode =  join "", map { $map{$_} || $_ } @chars;
    if( $highlightTaamim){

	# FIX this is broken for non-CO modes.
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
