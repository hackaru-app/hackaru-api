import c3 from 'c3';
import 'd3';

export function renderDonutChart(options) {
  c3.generate({
    bindto: '#donut-chart',
    data: {
      type: 'donut',
      columns: options.totals,
      colors: options.colors
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
}
