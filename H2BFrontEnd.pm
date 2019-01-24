package H2BFrontEnd;
# perhaps wants to be a subclass...
use utf8;
use common::sense;
use Moo;
use Method::Signatures;
use H2BEncoder;
use Unicode::Normalize qw(decompose reorder NFC NFD);

use namespace::clean;
has mode => (
    is => 'ro',
    default => 'CP',
    );


# allowed values HEH_BCFT
# allowed values HEH_BGDCFT
# allowed values ALL
has dageshMode => (
    is => 'rw',
    default => 'HEH_BGDCFT',	# dagesh kal (mostly)  + mapiq
    );

has highlightTaamim => (
    is => 'rw',
    default => '',
    );

has addSpace => (
    default => 1,
    is => 'rw',
    );


has counter => (
    is => 'rw',
    );

method getEncoder(){
    my $enc = H2BEncoder->new(mode => 'CP', dageshMode => $self->dageshMode);
return $enc;
}

method incCounter(){
    $self->counter($self->counter+1);
}
method resetCounter(){
    $self->counter(0);
}
method getBRF($inputHebrew){
    my $enc = $self->getEncoder();
    my $line = NFD($inputHebrew);
    my $p1Pure = $enc->heb2BrUni($line);
    my $p2 = $enc->brUni2BrAscii($p1Pure);
    $p2 =~ s/=/ /g;		# dont actually need to code zeroes. better with spaces for now.
    return $p2;
}

method _addWordNums($line, $isBraille ){
    my $splitter = ($isBraille? qr/\N{BRAILLE PATTERN BLANK}/ :  ' ');
    my $joiner = ($isBraille? "\N{BRAILLE PATTERN BLANK}" : " ");
    my $prefix = ($isBraille? "br-" : "tr-");
    my @words = split($splitter, $line);
    my $str =  join $joiner,  map {$self->incCounter(); qq{<span class="${prefix}word" id="${prefix}}.$self->counter.qq{">$_</span>};}  @words;
    return $str;
}


#return ($hebrewHTML, $brailleHTML) with html support for display
method getParallelHebrewBraille($inputHebrew){
    my $text =  NFD($inputHebrew);
    my @lines = split /\r?\n/, $text;
    $self->counter(0);
    my $hebrewHTML = join "\n" ,map {$self->_addWordNums($_,0)} @lines;
    $self->counter(0);
# say $enc->brailleReorder($line) if $debugReorder;
    my $enc = $self->getEncoder();
    my $p1 = join "\n", map { $enc->heb2BrUni($_, highlightTaamim => $self->highlightTaamim)} @lines;
    $p1 =~ s{\N{BRAILLE PATTERN BLANK}}{\N{BRAILLE PATTERN BLANK} }g if $self->addSpace;
    # $p1 =~ s{\N{HEBREW PUNCTUATION SOF PASUQ}}{\N{HEBREW PUNCTUATION SOF PASUQ}\N{BRAILLE PATTERN BLANK}}g if $self->addSpace;
    $p1 =~ s{\n}{\N{BRAILLE PATTERN BLANK}\n}g if $self->addSpace;
    $self->counter(0);
    my $brailleHTML =   $self->_addWordNums($p1, 1);
    return ($hebrewHTML, $brailleHTML);
}


1;
