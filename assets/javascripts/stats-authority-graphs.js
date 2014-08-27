(function($) {
  $(document).ready(function() {
    var $placeholder = $('#stats_chart');
    var data = $placeholder.data('stats');

    $placeholder.width('320px');
    $placeholder.height('180px');

    $.plot($placeholder, [ data ], {
      series: {
        bars: {
          show: true,
          barWidth: 0.6,
          align: 'center',
        }
      },
      yaxis: {
        tickDecimals: 0
      },
      xaxis: {
        mode: 'categories',
        tickLength: 0
      }
    });
  });
})($);