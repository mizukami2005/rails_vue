$(document).on('ready page:load', function () {
    $('#all').on('change', function () {
        $('input[id=user_ids_]').prop('checked', this.checked);
    });

    $('#follow').on('click', function () {
        $('#fuga').fadeIn();
        $('#fuga').fadeOut();
    });
});


