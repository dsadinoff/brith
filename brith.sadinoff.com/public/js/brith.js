 "use strict";

$(document).ready(function(){
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
    
});
