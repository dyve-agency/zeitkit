$(document).on('ready page:change', function() {
  $('.datepicker').datetimepicker({
       icons: {
          date: 'fa fa-calendar',
          time: 'fa fa-clock-o',
          up: 'fa fa-chevron-up',
          down: 'fa fa-chevron-down'
      },
      direction: 'bottom',
      pickTime: false
  });
});

$(document).on('ready page:change', function() {
  $('.datetimepicker').datetimepicker({
       icons: {
          date: 'fa fa-calendar',
          time: 'fa fa-clock-o',
          up: 'fa fa-chevron-up',
          down: 'fa fa-chevron-down'
      },
      direction: 'bottom',
pickSeconds: false
  });
});

$(document).on('ready page:change', function() {
  $('.timepicker').datetimepicker({
       icons: {
          date: 'fa fa-calendar',
          time: 'fa fa-clock-o',
          up: 'fa fa-chevron-up',
          down: 'fa fa-chevron-down'
      },
      direction: 'bottom',
      pickDate: false,
      pickSeconds: false
  });
});
