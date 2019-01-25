package Sefaria;
use utf8;
use common::sense;
use JSON qw();
use Moo;
use Method::Signatures;
use LWP::Simple;
use namespace::clean;



method fetch($spec){
    return join ("\n", $self->_fetch($spec));
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
method fetchViaManifest($manifest){
    my @lines  = ();
    for my $spec (@$manifest){
	if( $spec->{literal}){
	    push @lines,  $spec->{literal};
	}
	else{
	    push @lines, "[" .  $spec->{name}  . "]";
	    push @lines,$self->_fetch($spec->{passage});
	}
    }
    return join "\n",@lines;
}

#grab data from sefaria;
method _fetch($spec){
    #https://www.sefaria.org.il/api/texts/Exodus.10.1-11?commentary=0&context=1&pad=0&wrapLinks=1
    my $url = "https://www.sefaria.org.il/api/texts/${spec}?commentary=0&context=1&pad=0&wrapLinks=1";
    my $json = qx(curl -s "$url") or die "failed to get $url";
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

    return @lines;
}


1;
