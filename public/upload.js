/* upload.js
 *
 * Transparency Toolkit - DocUploader
 */

var pickedFiles = []
var uploadStatus = []

var uploadSingleFile = function(file, id) {
    var ajax = new XMLHttpRequest()

    // Progress listener
    ajax.upload.addEventListener('progress', function(e) {
        var percent = (e.loaded / e.total) * 100
        $('#progress-bar-' + id).find('progress-bar').attr('aria-valuenow', percent).css('width', percent + '%')
        $('#progress-bar-' + id).find('sr-only').html(percent + '% Complete')
        var uploaded = (e.loaded / 1048576).toFixed(2) + " MB of " + (e.total / 1048576).toFixed(2) + ' MB'
        var message = Math.round(percent) + '% completed ' + uploaded  + ' uploaded'
        $('#progress-status-' + id).text(message)

        if (percent == 100) {
            $('#progress-bar-' + id).addClass('hide')
        }

    }, false)

    // Load listener
    ajax.addEventListener('load', function(res) {
        if (res.target.status == 500) {
            $('#progress-status-' + id).text('Unknown error uploading file')
            return
        }

        var response = JSON.parse(res.target.responseText)
        if (response.status == 'success') {
            uploadStatus.push('done')
            if (uploadStatus.length == pickedFiles.length) {
                $('#files').html('')
                $('#status-done').removeClass('hide')
                $('#buttons-main').addClass('hide')
            } else {
                $('#progress-status-' + id).text(response.message)
                $('#progress-bar-' + id).css('width', '100%')
            }
        }

        // Hide Cancel button
        var btnCancel = $('#cancel-' + id)
        btnCancel.hide()
    }, false)

    ajax.addEventListener("error", function(e) {
        $('#progress-status-' + id).text('Uploading file failed')
    }, false)

    ajax.addEventListener("abort", function(e) {
        $('#progress-status-' + id).text('Uploading file aborted')
    }, false)

    // Prepare formfata
    ajax.open('POST', '/upload')
    var uploadForm = new FormData()
    uploadForm.append('project', $('input[name=project]').val())
    uploadForm.append('file' + id, file)
    uploadForm.append('title' + id, $('#doc_title' + id).val())
    uploadForm.append('description' + id, $('#doc_description' + id).val())

    // Hide & Show
    $('#file-fields-' + id).addClass('hide')
    $('#progress-' + id).removeClass('hide')

    // Start
    ajax.send(uploadForm)
    var btnCancel = $('#cancel-' + id)
        btnCancel.show()
        btnCancel.on('click', function() {
            console.log('kjadlkjda')
            ajax.abort()
        })
}

var uploadFiles = function() {
    for (var i = 0; i < pickedFiles.length; i++) {
        uploadSingleFile(pickedFiles[i], i)
    }
}

var returnFileSize = function(number) {
    if (number < 1024) {
        return number + 'bytes'
    } else if(number >= 1024 && number < 1048576) {
        return (number/1024).toFixed(1) + 'KB'
    } else if(number >= 1048576) {
        return (number/1048576).toFixed(1) + 'MB'
    }
}

var renderFile = function(template_file, file, count) {
    var id = template_file.replace(new RegExp('{{ID}}', 'g'), count)
    var filename = id.replace('{{FILENAME}}', file.name)
    var output = filename.replace('{{FILESIZE}}', file.size)
    return output
}

$(document).ready(function () {

    $('input[type=file]').change(function(e) {
        var template_file = $('#template-file').html()
        $(e.currentTarget.files).each(function(count, file) {
            if (count == 0 && pickedFiles.length > 0) {
                count = (pickedFiles.length)
            }
            pickedFiles.push(file)
            var html_item = renderFile(template_file, file, count)
            $('#files').append(html_item)
        })

        $('#button-upload').prop("disabled", false)
    })

    $('#button-upload').on('click', function(e) {
        e.preventDefault()
        uploadFiles()
    })

})
