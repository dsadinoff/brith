package Sefaria;
use utf8;
use common::sense;
use JSON qw();
use Moo;
use Function::Parameters;
use LWP::UserAgent;
use namespace::clean;



method fetch($spec, :$allowMarkup=undef){
    return join ("\n", $self->_fetch($spec, allowMarkup=>$allowMarkup));
}

#pass in an arrayref of hashes of form
# #  {
#     "name": "מפטיר",
#     "passage": "Exodus.13.14-16"
#   },
#   {
#     "literal": "\n"
#   },
#   {
#     "name": "הפתרה",
#     "passage": "Jeremiah.46.13-28"
#   }
method fetchViaManifest($manifest, :$allowMarkup=undef){
    my @lines  = ();
    for my $spec (@$manifest){
	if( $spec->{literal}){
	    push @lines,  $spec->{literal};
	}
	else{
	    push @lines, "[" .  $spec->{name}  . "]";
	    if( $spec->{passages}){
		for my $passage (@{$spec->{passages}}){
		    push @lines,$self->_fetch($passage, allowMarkup=>$allowMarkup);
		}
	    }
	    else{
		push @lines,$self->_fetch($spec->{passage}, allowMarkup=>$allowMarkup);
	    }
	}
    }
    return join "\n",@lines;
}

#grab data from sefaria;
method _fetch($spec, :$allowMarkup){
    #https://www.sefaria.org.il/api/texts/Exodus.10.1-11?commentary=0&context=1&pad=0&wrapLinks=1
    my $url = "https://www.sefaria.org.il/api/texts/${spec}?commentary=0&context=1&pad=0&wrapLinks=1";
    # warn ("url is : $url");
    my $ua = LWP::UserAgent->new();
    # eyeroll
    $ua->agent('Sefaria fetcher for BRiTH project');
    my $res = $ua->get($url);
    if(!  $res->is_success){
	die "failed to get $url, ".$res->status_line();
    }
    my $json =  $res->content;
    my $obj = JSON::decode_json($json);
    my @lines;
    if( $obj->{isSpanning}){
	my $spanIndex =0 ;
	for my $spanSpec (@{$obj->{spanningRefs}}){
	    my $srcAref = $obj->{he}[$spanIndex];
	    my ($begSpec, $endSpec) = $spanSpec =~ m/:(?:(\d+)-)?(\d+)/;
	    if( ! $begSpec ){
		$begSpec = $endSpec;
	    }
	    my $firstIndex = $begSpec -1;
	    my $lastIndex = $endSpec -1;
	    push @lines, @{$srcAref}[$firstIndex..$lastIndex];
	    
	    
	    $spanIndex++;
	}
	
    }
    else{
	
	my $spanSpec =  $obj->{ref};
	my $srcAref = $obj->{he};
	if( $spanSpec =~ m/\d/){
	    my ($begSpec, $endSpec) = $spanSpec =~ m/:(?:(\d+)-)?(\d+)/;
	    if( ! $begSpec ){
		$begSpec = $endSpec;
	    }
	    my $firstIndex = $begSpec -1;
	    my $lastIndex = $endSpec -1;
	    push @lines, @{$srcAref}[$firstIndex..$lastIndex];
	}
	else{
	    if( 'ARRAY' eq ref $srcAref->[0] ){
		push @lines, @{$srcAref->[0]}
	    }
	    else{
		push @lines, @$srcAref;
	    }
	}
    }
    return @lines if $allowMarkup;

    return map {removeMarkup($_)}  @lines;
}

=pod

1) samekh
 עַל־זֹ֖את הֱקִיצֹ֣תִי וָאֶרְאֶ֑ה וּשְׁנָתִ֖י עָ֥רְבָה לִּֽי׃ <span class="mam-spi-samekh">{ס}</span>
2)  pe: 
בִּבְכִ֣י יָבֹ֗אוּ וּֽבְתַחֲנוּנִים֮ אֽוֹבִילֵם֒ אֽוֹלִיכֵם֙ אֶל־נַ֣חֲלֵי מַ֔יִם בְּדֶ֣רֶךְ יָשָׁ֔ר לֹ֥א יִכָּשְׁל֖וּ בָּ֑הּ כִּֽי־הָיִ֤יתִי לְיִשְׂרָאֵל֙ לְאָ֔ב וְאֶפְרַ֖יִם בְּכֹ֥רִי הֽוּא׃ <span class="mam-spi-pe">{פ}</span><br>
3) qeri + ketiv
הַצִּ֧יבִי לָ֣ךְ צִיֻּנִ֗ים שִׂ֤מִי לָךְ֙ תַּמְרוּרִ֔ים שִׁ֣תִי לִבֵּ֔ךְ לַֽמְסִלָּ֖ה דֶּ֣רֶךְ <span class="mam-kq"><span class="mam-kq-k">(הלכתי)</span> <span class="mam-kq-q">[הָלָ֑כְתְּ]</span></span> שׁ֚וּבִי בְּתוּלַ֣ת יִשְׂרָאֵ֔ל שֻׁ֖בִי אֶל־עָרַ֥יִךְ אֵֽלֶּה׃

4) small pseq
וְכׇל־הָעֵ֣מֶק הַפְּגָרִ֣ים <small>׀</small> וְהַדֶּ֡שֶׁן

5) big yod

5) bold pseq
כֹּ֣ה <b>׀</b> אָמַ֣ר ה ק֣וֹל בְּרָמָ֤ה נִשְׁמָע֙

6)
<br>

7) 
footnotes e.g. 
./fetchSefaria Deuteronomy.21.22-22.7
<sup class="footnote-marker">*</sup><i class="footnote">(בספרי תימן <big>קַ</big>ן בקו״ף גדולה)</i>


=cut

sub removeMarkup{
    s{<span class="mam-spi-samekh">(.*?)</span>}{$1}g;
    s{<span class="mam-spi-pe">(.*?)</span>}{$1}g;

    # queri uktiv
    s{<span class="mam-kq-k">(.*?)</span>}{$1}g;
    s{<span class="mam-kq-q">(.*?)</span>}{$1}g;
    s{<span class="mam-kq(?:-trivial)?">(.*?)</span>}{$1}g;


    # footnotes
    s{<sup class="footnote-marker">\*</sup><i .*?</i>}{}g;

    # inverted Nun
    s{<span class="mam-spi-invnun">(.*?)</span>}{$1}g;


    s{<small>(.*?)</small>}{$1}g;
    s{<big>(.*?)</big>}{$1}g;
    s{<b>(.*?)</b>}{$1}g;
    s{<br>}{}g;

    return $_;
}
1;
