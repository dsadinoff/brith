 "use strict";

var currentResponse = {};

// Initialize the widget when the DOM is ready ';



function processServerDisplayResponse(obj){
    currentResponse = obj
    console.log(currentResponse);
    $('.display').show();
    $('.hebrew-col').html(currentResponse.hebrew);
    $('.braille-col').html(currentResponse.braille);
}


$(document).ready(function(){
    function clearOutput(){
	$('.hebrew-col').empty();
	$('.braille-col').empty();
	$('.display').hide();
    }
    function setupMouseOverEvents(){
	$('.braille-col').on('mouseenter','.br-word',
			     function(e){
				 var idnum =this.id.substr(3);
				 var theID = "tr-"+idnum;
				 $('#'+theID).addClass('highlight');
				 $(this).addClass('highlight');
			     });
	
	
	$('.hebrew-col').on('mouseenter','.tr-word',
			    function(e){
				var idnum =this.id.substr(3);
				var theID = "br-"+idnum;
				$('#'+theID).addClass('highlight');
				$(this).addClass('highlight');
			    });
	
	$('.hebrew-col,.braille-col').on('mouseleave','.br-word,.tr-word',
					 function(e){
					     $('.highlight').removeClass('highlight');
					 }
					);
	
    }
    function setupFetchSefaria(){
	function fetchUserSuppliedSpec(){
	    clearOutput();
	    var passageName = "ספריה";
	    var ref = $('#sefaria-ref').val();
	    $.ajax({
		url:'/translate-sefaria',
		method: 'post',
		contentType:'application/json',
		data: JSON.stringify({
		    manifest :[
			{
			    "name": passageName,
			    "passage": ref
			},
		    ]
		}),
		success:function(data,status, jxhr){
		    console.log(data,status);
		    processServerDisplayResponse( data);
		    
		}
	    }
		  );
	}

	$('.fetch-passage').click(fetchUserSuppliedSpec);

	$('input#sefaria-ref').bind("enterKey",fetchUserSuppliedSpec);
	$('input#sefaria-ref').keyup(function(e){
	    if(e.keyCode == 13)
	    {
		$(this).trigger("enterKey");
	    }
	});
	
    }

    function setupUpload(){
	$('#activateFileUpload').click(function(){
	    $('#uploader').show(300);
	    $('#activateFileUpload').hide(200);
	    clearOutput();
	});

	$('.download-brf').click(function(){
	    window.location.href=currentResponse.path;
	});

	$("#uploader").plupload({
	    // General settings
	    runtimes : 'html5,html4',
	    url : "/translate-file",
	    
	    // Maximum file size
	    max_file_size : '2mb',
	    
	    chunk_size: '1mb',
	    
	    // Specify what files to browse for
	    filters : [
		
		
	    ],
	    
	    // Rename files by clicking on their titles
	    rename: true,
	    
	    // Sort files
	    sortable: true,
	    
	    // Enable ability to drag'n'drop files onto the widget (currently only HTML5 supports that)
	    dragdrop: true,
	    
	    // Views to activate
	    views: {
		list: true,
		thumbs: false, // Show thumbs
		active: 'list'
	    },
	    multi_selection: false,
	    multipart_params:{
		fmt : 'displayMarkup'
	    },
	    init:{
		FileUploaded: function(up,file,info){
		    var resp = JSON.parse(info.response);
		    processServerDisplayResponse(resp);
		}	  
	    }
	    
	});
    }
    
    setupMouseOverEvents();
    setupFetchSefaria();
    setupUpload();
    
});
