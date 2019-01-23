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
    
    info("uploaded: ".Dumper(keys(%$allUploads))
	 ." headers = ".Dumper($upload->headers)
	 # ." data = $content "
	);

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
    my $filename = 'output.brf';
    my $publicPath = "download/$random/$filename";
    my $url = "https://brith.sadinoff.com/$publicPath";
    info("pwd is ".`/bin/pwd`);
    mkdir $dirname or info("couldnt mkdir $dirname: $!");

    open ( my $out,">", "$dirname/$filename") or info("couldnt open $dirname/$filename: $!");
    binmode($out, ":utf8");
    
    print $out  $brf;
    close $out;

    return JSON::encode_json({ path => $url});

    # template('uploads-test',{
    # 	msg => get_flash(),
    # 	translate_url => uri_for('/translate'),
    # 	allUploads => $allUploads,
    # 	     });

    # my $handle = $upload->file_handle;
    # my $outputFH = tempfile("translate.XXXX");
    # while(<$handle>){
    # 	print $outputFH "hello there!: $_";
    # }

    # $outputFH->flush();
    # $outputFH->seek(0,SEEK_SET);
    # send_file($outputFH, "content_type" => "text/plain" ,charset => 'utf-8');

};
 
dance;
