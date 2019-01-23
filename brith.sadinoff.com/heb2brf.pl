#!/usr/bin/env perl
use Dancer2; 

use Data::Dumper;
use JSON ();
use File::Slurper qw/read_text/;

use lib'/home/dsadinoff/github/brith/';
use IO::Handle;
use File::Temp qw/ :seekable /;
use common::sense;
use v5.10;
use H2BEncoder;
use Unicode::Normalize qw(decompose reorder NFC NFD);


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
 

post '/translate-file' => sub {
    my $allUploads = request->uploads();
    
    my $upload = $allUploads->{file}; # not sure what "file" means here. 
    my $uploadFile = $upload->tempname;
    my $content = read_text($uploadFile,'utf8');
    my @keys = body_parameters->keys();
    
    info("body parameters keys = ".Dumper(\@keys));
    info("body parameters  = ".Dumper(body_parameters));
    info(
	"uploaded: ".Dumper(keys(%$allUploads))
	 ." headers = ".Dumper($upload->headers)
	 # ." data = $content "
	);
    my $srcName = body_parameters->get('name');
    my $tEncoding ='CP';
    my $dageshMode ='HEH_BCFT';
    my $encoder = H2BEncoder->new(mode => $tEncoding, dageshMode => $dageshMode);
    my $p1Pure = $encoder->heb2BrUni($content);
    info("pure = $p1Pure");
    my $brf = $encoder->brUni2BrAscii($p1Pure);
    info("brf = $brf");



    content_type "application/json";
    my $random = rand();
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

    return JSON::encode_json({ path => $url});

};
 
dance;
