let Table = []
let Opened = false

function TriggerClasses(shells) {
    for (var i=0; i < shells.length; i++) {
        let elementId = shells[i].name
        const maxLength = 20;
        const ShellLabel = shells[i].name.length > maxLength ? shells[i].name.substring(0, maxLength) + '': shells[i].name;
        let string = `
        <div id="${elementId}" class="neen-boxes selectDisable">
        <img src="${shells[i].url}" data-toggle="modal" data-target="#imageModal" data-imgurl="${shells[i].url}">
            <div class="button-container">
                <button class="neen-button green" onclick="PreviewData('${elementId}')">Preview</button>
                <button class="neen-button yellow" onclick="GoInside('${elementId}')">Go inside</button>
            </div>
            <div class="neen-shell-name selectEnable">${ShellLabel}</div>
        </div>
        `;
        Table.push(string)
    }
    $(".neen-boxes-flex").html(Table.join(""));  
}

function PreviewData(Prev) {
    $.post(`https://${GetParentResourceName()}/PreviewInformation`, JSON.stringify({shellid:Prev}));
}

function GoInside(Go) {
    $.post(`https://${GetParentResourceName()}/InsideInformation`, JSON.stringify({shellid:Go}));
}

function CloseUi() {
    $(".neen-main-container").fadeOut(500)
    $.post(`https://${GetParentResourceName()}/CloseShellUi`, JSON.stringify({}));
}

function PreviewImagesshits(bool) {
    if (bool) {
        $(".neen-closebutton").fadeOut(250)
        $(".neen-credits").fadeOut(250)
        $(".neen-boxes-flex").fadeOut(250)
    } else {
        $(".neen-closebutton").fadeIn(250)
        $(".neen-credits").fadeIn(250)
        $(".neen-boxes-flex").fadeIn(250)
    }
}

$('.neen-image-previewer .modal-body img').on('click', function () {
    $('.neen-image-previewer').fadeOut(250);
    PreviewImagesshits(false)
});

$('.neen-image-previewer').on('click', function () {
    $(this).fadeOut(500);
});

$('.neen-image-previewer .modal-body').on('click', function (event) {
    event.stopPropagation();
});

window.addEventListener('message', function(event) {
    let data = event.data
	switch (event.data.action) {
		case 'LoadShells':
            TriggerClasses(data.shells)
        break
        case 'OpenShellui':
            $(".neen-main-container").fadeIn(500)
        break
        case 'CloseShellUI':
            $(".neen-main-container").fadeOut(500)
        break
    }
});

$(document).on("keydown", function (event) {
    if (event.key === "Escape" || event.keyCode === 27) {
        CloseUi()
    }
});

$(document).on('click', 'img[data-toggle="modal"]', function () {
    let imageUrl = $(this).data('imgurl');
    PreviewImagesshits(true)
    $('.neen-image-previewer').find('.modal-body img').attr('src', imageUrl);
    $('.neen-image-previewer').fadeIn(500);
});