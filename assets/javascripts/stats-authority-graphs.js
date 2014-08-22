(function() {
  $(document).ready(function() {
    var placeholder = $("#stats_chart");

    placeholder.width('280px');
    placeholder.height('150px');

    $.plot(placeholder, data, {
      series: {
        pie: {
          innerRadius: 0.5,
          show: true
        }
      }
    });
  });
})();