$ ->
  $('.dropdown-toggle').dropdown()
  $('.tooltip-init').tooltip()
  $('.datepicker').datepicker({
    autoclose: true,
    todayBtn: true,
    todayHighlight: true,
    format: "dd/mm/yyyy"
  })
  $('.timepicker').timepicker({
    minuteStep: 1,
    secondStep: 5,
    showSeconds: true,
    showMeridian: false,
    defaultTime: false
  })
