#!/usr/bin/env perl
use Dancer2; 

use Data::Dumper;
use JSON ();
use File::Slurper qw/read_text/;

use IO::Handle;
use File::Temp qw/ :seekable /;
use common::sense;
use v5.10;
use Unicode::Normalize qw(decompose reorder NFC NFD);
use Method::Signatures;
use lib'/home/dsadinoff/github/brith/';

use H2BFrontEnd;
use Sefaria;

#fix: cleanup download directory

sub set_flash {
    my $message = shift;
 
    session flash => $message;
}
 
sub get_flash {
    my $msg = session('flash');
    session->delete('flash');
 
    return $msg;
}
 
get '/hello/:name' => sub {
    state $counter =1;
    return "Why, hello there $$," . route_parameters->get('name') . $counter++;
};

get '/' => sub {

    redirect('/translate');
};
 
get '/translate' => sub {

    state $counter =1;
  
    template('hello.tt',{
	msg => get_flash(),
	translate_url => uri_for('/translate'),
	     });
};


 
#pass in utf8 hebrew
#get back *three* results:  hebrew <=>  braille html and BRF in a file
func encodeAndReturn($content, $srcName?){
    my $srcName = $srcName || body_parameters->get('name');
    $srcName =~ s/[^-0-9a-zA-Zא-ת_. ]/_/g;
    # my $fmt = body_parameters->get('fmt');
    my $tEncoding ='CP';
    my $dageshMode = body_parameters->get('dageshMode') || 'HEH_BCFT';
    my $encoder = H2BFrontEnd->new(mode => $tEncoding, dageshMode => $dageshMode, highlightTaamim=> 1);
    my $brf = $encoder->getBRF($content);


    my ($hebrew, $braille) = $encoder->getParallelHebrewBraille($content);

    info("brf = $brf");

    content_type "application/json";
    my $random = rand() . rand() . rand();
    my $dirname = "public/download/$random";
    my $filename = "output-$srcName.brf";
    my $publicPath = "download/$random/$filename";
    my $url = "https://brith.sadinoff.com/$publicPath";
    info("pwd is ".`/bin/pwd`);
    mkdir $dirname or info("couldnt mkdir $dirname: $!");

    open ( my $out,">", "$dirname/$filename") or info("couldnt open $dirname/$filename: $!");
    binmode($out, ":utf8");
    
    print $out  $brf;
    close $out;

    return JSON::encode_json({ path => $url,
			       hebrew => $hebrew,
			       braille => $braille
			     });


}

post '/translate-sefaria' => sub{
    my $postObj = from_json( request->body );
    info(Dumper($postObj));
    my $sefaria = Sefaria->new();


    if( $postObj->{manifest}){
	my $source = $sefaria->fetchViaManifest($postObj->{manifest});
	my $filename = $postObj->{manifest}[0]{passage} || 'unknown';
 	info("filename = $filename");
	return encodeAndReturn($source, $filename);
    }
    else{
	my $spec = "Exodus:1.5-10";
	my $source = $sefaria->fetch($spec);
	return encodeAndReturn($source, $spec);
    }
};

post '/translate-file' => sub {
    my $allUploads = request->uploads();
    
    my $upload = $allUploads->{file}; # not sure what "file" means here. 
    my $uploadFile = $upload->tempname;
    my $content = read_text($uploadFile,'utf8');
    # my @keys = body_parameters->keys();


    # info("body parameters keys = ".Dumper(\@keys));
    info("body parameters  = ".Dumper(body_parameters));
    # info(
    # 	 ." headers = ".Dumper($upload->headers)
    # 	 # ." data = $content "
    # 	);

    return encodeAndReturn($content);
};
 
dance;
