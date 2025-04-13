function messageBox(flag,mess,setf,wsize,jobs,addmessyn){
	if(!!$("#messageDialog")){
         $("#messageDialog").remove();
    }

    /*
    확인(OK)/예(Yes)/아니요(No)/취소(Cancel)
    OK
    OK/Cancel
    Yes/No
    Yes/No/Cancel 

    1.MessageBox    
    2.Question       
    3.Information    
    4.Warning       
    5.Error 
    */
       
    /**
     * Bootstrap’s JavaScript modal plug-in to add dialogs
     * JavaScript의 alert를 대신할 수 있는 단순한 형태의 모달 창을 표시
     * @param option
     * backdrop:"true","false","static"(static for a backdrop which doesn't close the modal on click.), default is "static"
     * bg_color: modal-header에 사용할 수 있는 background color 
     * 단순한 헤더 컬러:"bg-primary", "bg-success", "bg-info", "bg-warning", "bg-danger", "bg-secondary", "bg-dark" and "bg-light"
     * Alert를 위한 컬러:"alert-primary", "alert-secondary", "alert-success", "alert-danger", "alert-warning", "alert-info", "alert-light", "alert-dark"
     * default is "bg-info"
     * title:"" 모달 창의 타이틀,
     * contents:"" 모달 창에 표시할 본문 내용,
     * focusedId:"" 모달 창을 닫을 때 포커스할 부모 창의 엘리먼트 ID
     * maxWidth:"" 모달 창의 사이즈를 표시(단위: px 고정)
     * draggable:"false" 모달 창을 드레그할 수 있도록 한다.(https://code.jquery.com/ui/1.12.1/jquery-ui.min.js)
     * contentHref: ajax로 호출할 컨텐트의 내용
     * @returns
     */
	
	if(!wsize){
		wsize = 35;
	}
	
	
    switch (flag) {
        case "1": // MessageBox
            var option ={
                backdrop   : "true",
                bg_color   : "bg-blue", 
                title      : "MessageBox",
				width_size : '' + wsize + '',
                contents   : '' + mess  + '',
                focusedId  : '' + setf  + '',
                buttons    : '<button type="button" class="btn btn-blue data-dismiss="modal" onClick="modalClose()">확인(OK)</button>',
                maxWidth   : window.innerWidth,
                draggable  : "true",
                contentHref: ""
            }
            break;
        case "2": // Question
           	// 요청한곳에서 Yes 처리 할 경우 Confirm MessageBox를 사용하세요 !! 
            var option = {
                backdrop   : "static",
                bg_color   : "bg-info",  
                title      : "Question",
				width_size : '' + wsize + '',
                contents   : '' + mess + '',
                focusedId  : '' + setf + '',
                buttons    : '<button id="btnyes" type="button" class="btn btn-blue" data-dismiss="modal" onClick="modalClose(\'Y\', \'' + jobs + '\',\'' + addmessyn + '\')">예(Yes)</button>' +
                             '<button id="btn_no" type="button" class="btn btn-info" data-dismiss="modal" onClick="modalClose(\'N\', \'' + jobs + '\',\'' + addmessyn + '\')">노(No)</button>',
                maxWidth   : window.innerWidth,
                draggable  : "true",
                contentHref: ""
            };
        
            break;
        case "3": // Information 
            var option ={
                backdrop   : "true",
                bg_color   : "bg-success",
                title      : "Information",
				width_size : '' + wsize + '',
                contents   : '' + mess + '',
                focusedId  : '' + setf + '',
                buttons    : '<button type="button" class="btn btn-success data-dismiss="modal" onClick="modalClose()">확인(OK)</button>',
                maxWidth   : window.innerWidth,
                draggable  : "true",
                contentHref: ""
            }
            break;
        case "4": // Warning
            var option ={
                backdrop   : "static",
                bg_color   : "bg-warning",
                title      : "Warning",
                width_size : '' + wsize + '',
                contents   : '' + mess + '',
                focusedId  : '' + setf + '',
                buttons    : '<button type="button" class="btn btn-warning data-dismiss="modal" onClick="modalClose()">확인(OK)</button>',
                maxWidth   : window.innerWidth,
                draggable  : "false",
                contentHref: ""
            }
            break;
        case "5": // Error 
            var option ={
                backdrop   : "static",
                bg_color   : "bg-danger",
                title      : "Warning",
				width_size : '' + wsize + '',
                contents   : '' + mess + '',
                focusedId  : '' + setf + '',
                buttons    : '<button type="button" class="btn btn-danger data-dismiss="modal" onClick="modalClose()">확인(OK)</button>',
                maxWidth   : window.innerWidth,
                draggable  : "false",
                contentHref: ""
            }
            break;
		case "9": // Question
            var option = {
                backdrop   : "static",
                bg_color   : "bg-info",
                title      : "Confirm",
				width_size : '' + wsize + '',
                contents   : '' + mess + '',
                focusedId  : '' + setf + '',
                buttons    : '<button id="confirmYes" type="button" class="btn btn-blue" data-dismiss="modal" onClick="modalClose()">예(Yes)</button>' +
                             '<button id="confirmNo"  type="button" class="btn btn-info" data-dismiss="modal" onClick="modalClose()">노(No)</button>',
                maxWidth   : window.innerWidth,
                draggable  : "true",
                contentHref: ""
            }
            break;
       default:
            break;
    }   
    option = $.extend(option);
    var dialog =
    '<div class="modal fade" id="messageDialog" tabindex="-1" data-backdrop="' + option.backdrop + '" role="dialog" aria-hidden="false" data-keyboard="false">' +
    '  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="dialog">' +
    '    <div class="modal-content" style="width:' + option.width_size + '%;">' +
    '      <div class="modal-header ' + option.bg_color + '" style="text-align:center;">' +
    '        <h5 class="modal-title" id="alertTitle">' + option.title + '</h5>' +
    '        <button type="button" class="close" data-dismiss="modal" aria-label="Close" onClick="modalClose()">' +
    '          <span aria-hidden="true">&times;</span>' +
    '        </button>' +
    '      </div>' +
    '      <div class="modal-body" style="text-align:left;">' +
            option.contents +
    '      </div>' +
    '      <div class="modal-footer">' +
            option.buttons +
    '      </div>' +
    '    </div>' +
    '  </div>' +
    '</div>';
	$("body").append(dialog);
    $('#messageDialog').on('hidden.bs.modal', function () {
        if(option.focusedId !== ""){ $("#" + option.focusedId).focus();}
    });
    
    // 모달을 드레그할 수 있도록 처리
    if( option.draggable === "true"){
        
        // Make the DIV element draggable:
        var element = document.querySelector('#messageDialog');
        dragElement(element);

        function dragElement(elmnt) {
            var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
            if (elmnt.querySelector('.modal-content')) {
                // if present, the header is where you move the DIV from:
                elmnt.querySelector('.modal-content').onmousedown = dragMouseDown;
            } else {
                // otherwise, move the DIV from anywhere inside the DIV:
                elmnt.onmousedown = dragMouseDown;
            }

            function dragMouseDown(e) {
                e = e || window.event;
                // get the mouse cursor position at startup:
                pos3 = e.clientX;
                pos4 = e.clientY;
                document.onmouseup = closeDragElement;
                // call a function whenever the cursor moves:
                document.onmousemove = elementDrag;
            }

            function elementDrag(e) {
                e = e || window.event;
                // calculate the new cursor position:
                pos1 = pos3 - e.clientX;
                pos2 = pos4 - e.clientY;
                pos3 = e.clientX;
                pos4 = e.clientY;
                // set the element's new position:
                elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
                elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
            }

            function closeDragElement() {
                // stop moving when mouse button is released:
                document.onmouseup   = null;
                document.onmousemove = null;
            }
        }

    }
    
    // 모달의 사이즈를 조정할 수 있도록 처리  
    $('#messageDialog').on('show.bs.modal', function () {
        if( option.maxWidth !== ""){
            $(this).find('.modal-dialog').attr('style', 'max-width: ' + option.maxWidth + 'px;'); // modal.scss의 max-width를 override
        }
        $(this).find('.modal-body').css({'max-height':'100%'});
        if( option.contentHref !== ""){
            $(this).find(".modal-body").load(option.contentHref);
        }
    });
    $("#messageDialog").modal('show');
	
}

function CallRoutine(JobName, yesno) {
    let errflag = false;
    let errmess = "";

    // JobName에 따라 처리
    switch (JobName) {
		case "호출루틴명1":

            errmess = "<br> Error Message 내용입니다. <br>";
            errflag = true;
            break;
        case "호출루틴명2":
            
            break;	
		default:
        	   
            break;
    }

    $("#messageDialog").on('hide.bs.modal', function () {
        if (errflag) {
			messageBox("5", errmess, "");
        } else {
            if (yesno === "Y") {
                messageBox("3", "<br> 정상적으로 처리되었습니다. !! <br>", "");
            }
        }
    });	
}
function modalClose(flag, jobs, yesno){
	if (flag === "Y") {
        if (!jobs) { // jobs가 undefined, null, 또는 빈 문자열인지 확인
            $("#messageDialog").on('hide.bs.modal', function () {
                messageBox("5", "<br> 처리할 Routine 정보가 정의되지 않았습니다.(담당자 문의 필요) !! <br>", "");
            });
        } else {
            CallRoutine(jobs.trim(), yesno); // trim()으로 공백 제거
        }
    } else {
        // flag가 "Y"가 아닌 경우
        $("#messageDialog").on('hide.bs.modal', function () {
            if (yesno === "Y") {
                messageBox("3", "<br> 정상적으로 취소되었습니다. !! <br>", "");
            }
        });
    }
	$("#messageDialog").modal("hide");
};