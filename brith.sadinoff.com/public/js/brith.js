 "use strict";

var currentResponse = {};

// Initialize the widget when the DOM is ready ';

function stopSpinner(){
    $('.spinner-container').hide();
}

function processServerDisplayResponse(obj){
    currentResponse = obj
    console.log(currentResponse);
    stopSpinner();
    $('.display').show();
    $('.hebrew-col').html(currentResponse.hebrew);
    $('.braille-col').html(currentResponse.braille);
}


$(document).ready(function(){
    function clearOutput(){
	$('.hebrew-col').empty();
	$('.braille-col').empty();
	$('.display').hide();
	$('.spinner-container').show();
    }
    function highlightAndScroll(homeSide, highlightNotScroll){
	var thatPrefix;
	var thatClass;
	if( homeSide == 'braille'){
	    thatPrefix = 'tr-';
	    thatClass = '.hebrew-col';
	}
	else{
	    thatPrefix = 'br-';
	    thatClass = '.braille-col';
	    
	}
	return function(e){
	    var idnum =this.id.substr(3);
	    var theID = thatPrefix+idnum;
	    var thatDiv = $(thatClass)
	    if( highlightNotScroll){
		$('#'+theID).addClass('highlight');
		$(this).addClass('highlight');
	    }
	    else{
		// scroll
		$('#'+theID)[0].scrollIntoView();
	    }
	}
    }
    
    function setupMouseOverEvents(){
	$('.braille-col').on('mouseenter','.br-word',
			     highlightAndScroll('braille', true));
	$('.braille-col').on('click','.br-word',
			     highlightAndScroll('braille', false));

	$('.hebrew-col').on('mouseenter','.tr-word',
			    highlightAndScroll('hebrew', true));
	$('.hebrew-col').on('click','.tr-word',
			    highlightAndScroll('hebrew', false));

	
	$('.hebrew-col,.braille-col').on('mouseleave','.br-word,.tr-word',
					 function(e){
					     $('.highlight').removeClass('highlight');
					 }
					);
	
    }
    function setupFetchSefaria(){

	function fetchManifest(manifest){
	    clearOutput();
	    $.ajax({
		url:'/translate-sefaria',
		method: 'post',
		contentType:'application/json',
		data: JSON.stringify({
		    manifest : manifest,
		    dageshMode: $('#dageshSelect').val()
		}),
		success:function(data,status, jxhr){
		    console.log(data,status);
		    processServerDisplayResponse( data);
		    
		}
	    }
		  );
	    
	}
	
	function fetchUserSuppliedSpec(){
	    var passageName = "ספריה";
	    var ref = $('#sefaria-ref').val();
	    var manifest  = [
			{
			    "name": passageName,
			    "passage": ref
			},
	    ];
	    fetchManifest(manifest);	
	}
	
	function loadParshiot(){
	    var $select = $('select#manifest-selector');
	    $.each(parshiot, function(i ,elem){
		var $option = $('<option></option>');
		$option.text(elem.name + " - " + elem.hebrew );
		$option.val(i);
		$select.append($option);
		console.log(elem.hebrew);
	    });
	}
	

	$('.fetch-passage').click(fetchUserSuppliedSpec);

	$('input#sefaria-ref').bind("enterKey",fetchUserSuppliedSpec);
	$('input#sefaria-ref').keyup(function(e){
	    if(e.keyCode == 13)
	    {
		$(this).trigger("enterKey");
	    }
	});

	loadParshiot();
	$('.fetch-manifest').click(function(){
	    var parshaIndex = $('select#manifest-selector').val();
	    var parsha = parshiot[parshaIndex];
	    fetchManifest(parsha.manifest);
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
	    init:{
		FileUploaded: function(up,file,info){
		    var resp = JSON.parse(info.response);
		    processServerDisplayResponse(resp);
		},

		BeforeUpload:  function(uploader, file){
		    console.log("beforeUpload");
		    uploader.setOption({'multipart_params':
					{
					    fmt : 'displayMarkup',
					    dageshMode: $('#dageshSelect').val()
					}});
		}
	    }
	});
    }
    
    setupMouseOverEvents();
    setupFetchSefaria();
    setupUpload();
    
});
