import c3 from 'c3';
import 'd3';

const data = JSON.parse(
  document.getElementById('donut-chart').dataset.json
);

c3.generate({
  bindto: '#donut-chart',
  data: {
    type: 'donut',
    columns: data.totals,
    colors: data.colors
  },
  donut: {
    label: {
      show: false
    }
  },
  legend: {
    show: false
  }
});
