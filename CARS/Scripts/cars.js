$(document).ready(function () {
    loadInit();
    function loadInit() {
        pin("true", "true");
    }

    $('#pin').checkbox('attach events', '.toggle.button');
    $('#pin').on('click', function () {
        pin(pinned(), "false");
        if ($("#pin").is(':checked')) {
            pin("true", "false");
        }
        else {
            pin("false", "false");
        }
    });
    /* GENERAL FUNCTIONS */
    $('#click').on('click', function (e) {
        e.preventDefault();
        e.stopPropagation();
        $('#carsWrapper').toggleClass('on');
    });
    $('#carsSideBar #navigation > #on-hover').on('mouseover', function () {
        $('#carsWrapper').addClass('on');
    });
    $('#carsSideBar #navigation').on('mouseleave', function () {
        if (!pinned()) {
            $('#carsWrapper').removeClass('on');
        }
    });
    function pinned($var) {
        if ($("#pin").is(':checked')) {
            return true;
        }
        else {
            return false;
        }
    }

    function pin(flg, fetch) {
        var postData = "{'pinFlg': " + flg + ", 'pinFetch': " + fetch + "}";
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "/master/frmCFUserDetail.aspx/Pin_Switch_Check",
            data: postData,
            dataType: "json",
            //async: false,//Very important
            success: function (data) {
                if (data.d === 1) {
                        $('#pin').prop("checked", true);
                        $('#carsWrapper').addClass('on');
                } else {
                        $('#pin').prop("checked", false);
                        $('#carsWrapper').removeClass('on');
                }

            },
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.status);
                console.log(xhr.responseText);
                console.log(thrownError);
            }
        });
    }





    /*
      END GENERAL FUNCTIONS
    */
});
function systemMSG(type, string, duration) {
    var sysMSG = $('#systemMessage');
    sysMSG.html(string);
    
    switch (type) {
        case 'success':
            sysMSG.removeClass('negative info').addClass('success');
            break;
        case 'error':
            sysMSG.removeClass('success info').addClass('negative');
            break;
        default:
            sysMSG.removeClass('success negative').addClass('info');
    }
    sysMSG.removeClass('fadeOut').addClass('fadeIn');
    setTimeout(function () {
        sysMSG.addClass('fadeOut');
    }, duration);
}
function requiredFields(check, submitfield) {
    var reqInp
    submitfield ? reqInp = $('[data-required="REQUIRED"][' + submitfield + ']') : reqInp = $('[data-required="REQUIRED"]');
    var  error = false;
    $.each(reqInp, function (key, value) {
        var obj = $(value);
        var lbl = obj.parent('div').children('span, label');
        console.log(obj);
        lbl.addClass('required');
        if (check === true) {
            if ($.trim(obj.val()).length <= 0) {
                lbl.addClass('required-error');
                obj.addClass('required-error');
                error = true;
            }
        }
    });
    if (error === true) {
        systemMSG('error', 'Some required field are missing information.', 4000);
        return false;
    } else {
        $('.required-error').removeClass('required-error');
        return true;
    }
}
function clearFormElements(selector) {
    $(selector).find(':input').each(function () {
        switch (this.type) {
            case 'password':
            case 'text':
            case 'textarea':
            case 'file':
            case 'select-one':
            case 'select-multiple':
                $(this).val('');
                break;
            case 'checkbox':
            case 'radio':
                this.checked = false;
        }
    });
}

