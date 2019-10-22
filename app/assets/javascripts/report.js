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

c3.generate({
  bindto: '#bar-chart',
  data: {
    type: 'bar',
    columns: [
        ['data1', 30, 200, 100, 400, 150, 250],
        ['data2', 130, 100, 140, 200, 150, 50]
    ]
  },
  legend: {
    show: false
  }
});