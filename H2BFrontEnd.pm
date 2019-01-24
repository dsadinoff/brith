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
    is => 'rw',
    );

method getEncoder(){
    my $enc = H2BEncoder->new(mode => 'CP', dageshMode => $self->dageshMode);
return $enc;
}


method getBRF($inputHebrew){
    my $enc = $self->getEncoder();
    my $line = NFD($inputHebrew);
    my $p1Pure = $enc->heb2BrUni($line);
    my $p2 = $enc->brUni2BrAscii($p1Pure);
    $p2 =~ s/=/ /g;		# dont actually need to code zeroes. better with spaces for now.
    return $p2;
}

method _addWordNums($line, $isBraille, $counterStart?){
    my $counter = $counterStart||0;
    my $splitter = ($isBraille? "\N{BRAILLE PATTERN BLANK}" : " ");
    my $prefix = ($isBraille? "br-" : "tr-");
    my @words = split($splitter, $line);
    my $str =  join $splitter,  map {$counter++; qq{<span class="${prefix}word" id="${prefix}$counter">$_</span>};}  @words;
    return $str;
}


#return ($hebrewHTML, $brailleHTML) with html support for display
method getParallelHebrewBraille($inputHebrew){
    my $line =  NFD($inputHebrew);
    # my @lines = split /\r?\n/, $text;
    my $hebrewHTML = $self->_addWordNums($line,0);
# say $enc->brailleReorder($line) if $debugReorder;
    my $enc = $self->getEncoder();
    my $p1Pure = $enc->heb2BrUni($line);
    my $p1 = $enc->heb2BrUni($line, highlightTaamim => $self->highlightTaamim);

    $p1 =~ s{\N{BRAILLE PATTERN BLANK}}{\N{BRAILLE PATTERN BLANK} }g if $self->addSpace;
    my $brailleHTML =   $self->_addWordNums($p1, 1);
    return ($hebrewHTML, $brailleHTML);
}


1;
