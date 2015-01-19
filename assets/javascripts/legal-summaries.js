(function($) {

  var summarise = function summarise(){
    var $div = $(this);
    var $firstP = $('p:first-of-type', $div);
    var $extraElements = $firstP.nextAll();

    if($extraElements.length > 0){

      var readMore = '(Ver mas)';
      if($('html').attr('lang') != 'es'){
        var readMore = '(Read more)';
      }

      var $moreLink = $('<a>').on('click', function(){
        $(this).parent().nextAll().show();
        $(this).remove();
      }).text(readMore).addClass('read_more');

      $firstP.append(' ').append($moreLink).nextAll().hide();

    }
  }

  $(function(){
    $('.human_and_legal > div + div').each(summarise);
  })
})($);
