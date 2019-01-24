 "use strict";

$(document).ready(function(){
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



    setupMouseOverEvents();
    setupFetchSefaria();
    
});
