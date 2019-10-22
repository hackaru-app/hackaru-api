c3.generate({
  bindto: '#donut-chart',
  data: {
    type : 'donut',
    columns: [
        ['data1', 30],
        ['data2', 120],
    ]
  },
  donut: {
    padAngle: .015,
    label: {
      show: false
    }
  },
  legend: {
    show: false
  }
});