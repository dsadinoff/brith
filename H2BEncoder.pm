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


# allowed values HEH_BCFT
# allowed values HEH_BGDCFT
# allowed values ALL
has dageshMode => (
    is => 'rw',
    default => 'HEH_BGDCFT',	# dagesh kal (mostly)  + mapiq
    );


method brUni2BrAscii($input){
    $input =~ tr{⠁⠂⠃⠄⠅⠆⠇⠈⠉⠊⠋⠌⠍⠎⠏⠐⠑⠒⠓⠔⠕⠖⠗⠘⠙⠚⠛⠜⠝⠞⠟⠠⠡⠢⠣⠤⠥⠦⠧⠨⠩⠪⠫⠬⠭⠮⠯⠰⠱⠲⠳⠴⠵⠶⠷⠸⠹⠺⠻⠼⠽⠾⠿⠀}{A1B'K2L@CIF/MSP"E3H9O6R^DJG>NTQ,*5<\-U8V.%[$+X!&;:4\\0Z7(_?W]#Y)=};
    return $input;
}

method toMap($dataAref){
    my %map = (map {if( $_->{src}){ ($_->{src} => $_->{target})}else{()}} @$dataAref);
    return %map
}


# dagesh first,
# remove if requested
method brailleReorder($line){
    my $output = '';
    while( $line =~ m/(?:(?<letter>\p{L})(?<combiners>\p{M}*))|(?<nonLetters>\P{L}+)/xg){
	if( $+{letter}){
	    my $letter = $+{letter};
	    my $prefix ='';
	    my $comb = $+{combiners} //"";
	    if( $comb =~ s/\N{HEBREW POINT DAGESH OR MAPIQ}//){
		for( $self->dageshMode){
		    when('ALL'){
			$prefix = "\N{HEBREW POINT DAGESH OR MAPIQ}";
		    }
		    when('HEH_BCFT'){
			$letter=m/[הבכפת]/
			    and 
			    $prefix = "\N{HEBREW POINT DAGESH OR MAPIQ}";
		    }
		    when('HEH_BGDCFT'){
			$letter=m/[הבגדכפת]/
			    and 
			    $prefix = "\N{HEBREW POINT DAGESH OR MAPIQ}";
		    }
		    when('HEH_BGDCFT'){
			$letter=m/[הבגדכפת]/
			    and 
			    $prefix = "\N{HEBREW POINT DAGESH OR MAPIQ}";
		    }
		    default{
			die " unknown dagesh mode: ".$self->dageshMode;
		    }
		}
	    }
	    $output .= "${prefix}$letter${comb}";
	}
	else{
	    $output .= $+{nonLetters};

	}
    }
    return $output;
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

	{ src=>"["  , target=> "\N{BRAILLE PATTERN DOTS-6}\N{BRAILLE PATTERN DOTS-2356}"},
	{ src=>"]"  , target=> "\N{BRAILLE PATTERN DOTS-2356}\N{BRAILLE PATTERN DOTS-3}"},

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
		 
		 
		 { note => "above"},
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
	
	when('CO'){
	    
    # Clarity - Orthographic
    #this encoding uses an escape character .
	    return [
		{ src=>"-" ,target=> $hyphenMinusBraille,}
		,{ src=>"." ,target=> $periodBraille,}
		
		

		,{note => "This is a standard mentioned in the WP page. for the uncoded dagesh kal for ג,ד, dagesh chazak and mapiq"}
		,{ src=>"\N{HEBREW POINT DAGESH OR MAPIQ}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-1245}", note=>""} 

		,{ src=>"\N{HEBREW PUNCTUATION PASEQ}"   ,target=>"\N{BRAILLE PATTERN DOTS-456}\N{BRAILLE PATTERN DOTS-1256}", note=>"From the English for Vertical Bar"}
		
		
		# below
		,{note => "below"}
		#prefixed with "caps" dots-6
		,{ src=>"\N{HEBREW ACCENT MERKHA}"   ,target=>"$taamBelow\N{BRAILLE PATTERN DOTS-23}", note=>""}
		,{ src=>"\N{HEBREW ACCENT TIPEHA}"   ,target=>"$taamBelow\N{BRAILLE PATTERN DOTS-14}", note=>""}
		,{ src=>"\N{HEBREW ACCENT MERKHA KEFULA}"   ,target=>"$taamBelow\N{BRAILLE PATTERN DOTS-2345}", note=>""}
		,{ src=>"\N{HEBREW ACCENT ETNAHTA}"   ,target=>"$taamBelow\N{BRAILLE PATTERN DOTS-2}", note=>""}
		,{ src=>"\N{HEBREW ACCENT YERAH BEN YOMO}"   ,target=>"$taamBelow\N{BRAILLE PATTERN DOTS-13456}", note=>""}
		,{ src=>"\N{HEBREW ACCENT ATNAH HAFUKH}"   ,target=>"$taamBelow\N{BRAILLE PATTERN DOTS-13456}", note=>""} # aka Yerech ben yomo
		,{ src=>"\N{HEBREW ACCENT TEVIR}"   ,target=>"$taamBelow\N{BRAILLE PATTERN DOTS-1245}", note=>""}
		,{ src=>"\N{HEBREW ACCENT YETIV}"   ,target=>"$taamBelow\N{BRAILLE PATTERN DOTS-246}", note=>""}
		,{ src=>"\N{HEBREW ACCENT MUNAH}"   ,target=>"$taamBelow\N{BRAILLE PATTERN DOTS-356}", note=>""}
		,{ src=>"\N{HEBREW ACCENT MAHAPAKH}"   ,target=>"$taamBelow\N{BRAILLE PATTERN DOTS-145}", note=>""}
		
		# not a taam-ACCENT But belongs on the bottom.
		,{ src=>"\N{HEBREW POINT METEG}"   ,target=>"$taamBelow\N{BRAILLE PATTERN DOTS-12}", note=>""}
		
		
		# above
		#prefixed with "up-top" dots-3
		,{note => "above"}
		,{ src=>"\N{HEBREW ACCENT SEGOL}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-15}", note=>""} # cf HEBREW POINT SEGOL
		,{ src=>"\N{HEBREW ACCENT SHALSHELET}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-1356}", note=>""}
		,{ src=>"\N{HEBREW ACCENT ZAQEF QATAN}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-13}", note=>""}
		,{ src=>"\N{HEBREW ACCENT ZAQEF GADOL}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-12346}", note=>""}
		,{ src=>"\N{HEBREW ACCENT ZINOR}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-12345}", note=>""} # misnamed zarqa.  consider zayin instead?
		,{ src=>"\N{HEBREW ACCENT PASHTA}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-245}", note=>""}
		,{ src=>"\N{HEBREW ACCENT GERESH}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-12}", note=>""} # AKA Azla
		,{ src=>"\N{HEBREW ACCENT GERESH MUQDAM}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-12}", note=>""} # unified with geresh...
		,{ src=>"\N{HEBREW ACCENT GERSHAYIM}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-1256}", note=>""}
		,{ src=>"\N{HEBREW ACCENT REVIA}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-1235}", note=>""}
		,{ src=>"\N{HEBREW ACCENT QARNEY PARA}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-1346}", note=>""}
		
		,{ src=>"\N{HEBREW ACCENT PAZER}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-1236}", note=>""}
		,{ src=>"\N{HEBREW ACCENT DARGA}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-135}", note=>""}
		,{ src=>"\N{HEBREW ACCENT QADMA}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-124}", note=>""}
		
		,{ src=>"\N{HEBREW ACCENT TELISHA GEDOLA}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-1345}", note=>""}
		,{ src=>"\N{HEBREW ACCENT TELISHA QETANA}"   ,target=>"$taamAbove\N{BRAILLE PATTERN DOTS-1246}", note=>""}
		
		
		
		,{ src=>"\N{HEBREW PUNCTUATION NUN HAFUKHA}"   ,target=>"\N{BRAILLE PATTERN DOTS-12345678}", note=>""}

		# only in אמ"ת.  For completeness
		,{ src=>"\N{HEBREW ACCENT OLE}"   ,target=>"\N{BRAILLE PATTERN DOTS-12345678}", note=>""}
		,{ src=>"\N{HEBREW ACCENT ILUY}"   ,target=>"\N{BRAILLE PATTERN DOTS-12345678}", note=>""}
		,{ src=>"\N{HEBREW ACCENT DEHI}"   ,target=>"\N{BRAILLE PATTERN DOTS-12345678}", note=>""}
		,{ src=>"\N{HEBREW ACCENT ZARQA}"   ,target=>"\N{BRAILLE PATTERN DOTS-12345678}", note=>""} # actually a Tzinor
		
		# uncoded yet
		,{ src=>"\N{HEBREW MARK UPPER DOT}"   ,target=>"\N{BRAILLE PATTERN DOTS-12345678}", note=>""} # 
		,{ src=>"\N{HEBREW MARK LOWER DOT}"   ,target=>"\N{BRAILLE PATTERN DOTS-12345678}", note=>""} # 
		
		,{ src=>"\N{HEBREW POINT QAMATS QATAN}"   ,target=>"\N{BRAILLE PATTERN DOTS-12345678}", note=>""} # unify with Qamats?
		
		];
	}
    }
}

method getBasicDataMap(){
    return $self->toMap($self->basicData);
    
}

# convert hebrew to unicode Braille
method heb2BrUni($string, :$highlightTaamim) {

    $string = $self->brailleReorder($string);

    # in Sring, dageshes now IMMEDIATELY preceed the letter
    
    my @precomposed = (
	{ pat => qr"\N{HEBREW POINT DAGESH OR MAPIQ}\N{HEBREW LETTER BET}" , repl => "\N{BRAILLE PATTERN DOTS-12}"},

	{ pat => qr"\N{HEBREW POINT DAGESH OR MAPIQ}\N{HEBREW LETTER VAV}",repl => "\N{BRAILLE PATTERN DOTS-346}"}, # שורוק
	{ pat => qr"\N{HEBREW LETTER VAV WITH DAGESH}",repl => "\N{BRAILLE PATTERN DOTS-346}"}, #

	{ pat => qr"\N{HEBREW POINT DAGESH OR MAPIQ}\N{HEBREW LETTER KAF}",repl => "\N{BRAILLE PATTERN DOTS-13}"},
	{ pat => qr"\N{HEBREW POINT DAGESH OR MAPIQ}\N{HEBREW LETTER FINAL KAF}",repl => "\N{BRAILLE PATTERN DOTS-13}"},

	{ pat => qr"\N{HEBREW POINT DAGESH OR MAPIQ}\N{HEBREW LETTER PE}",repl => "\N{BRAILLE PATTERN DOTS-1234}"},
	{ pat => qr"\N{HEBREW POINT DAGESH OR MAPIQ}\N{HEBREW LETTER FINAL PE}",repl => "\N{BRAILLE PATTERN DOTS-1234}"},

	{ pat => qr"\N{HEBREW LETTER SHIN}\N{HEBREW POINT SHIN DOT}",repl => "\N{BRAILLE PATTERN DOTS-146}"},
	{ pat => qr"\N{HEBREW LETTER SHIN}\N{HEBREW POINT SIN DOT}",repl => "\N{BRAILLE PATTERN DOTS-156}"},


	{ pat => qr"\N{HEBREW POINT DAGESH OR MAPIQ}\N{HEBREW LETTER TAV}",repl => "\N{BRAILLE PATTERN DOTS-1256}"},

	#  at this point, dageshes are left preceeding the text.


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


    # Clarity - Phonetic
    #this encoding uses an escape character
    my $taamData =$self->getTaamData();
    
    my %taamimMap = (map {if( $_->{src}){ ($_->{src} => $_->{target})}else{()}} @$taamData);
    my %map = (%basicHebrew , %taamimMap);

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
