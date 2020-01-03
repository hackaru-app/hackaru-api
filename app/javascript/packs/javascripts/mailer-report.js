import c3 from 'c3';
import 'd3';

function getTickFormat(seconds) {
  const hours = seconds / 3600;
  return hours % 0.5 === 0 ? `${hours}h` : '';
}

c3.generate({
  bindto: '#bar-chart',
  data: {
    type: 'bar',
    columns: gon.global.bar_chart_data,
    colors: gon.global.colors,
    groups: [gon.global.groups]
  },
  legend: {
    show: false
  },
  axis: {
    x: {
      type: 'category',
      categories: gon.global.labels
    },
    y: {
      tick: {
        format: getTickFormat
      }
    }
  }
});


c3.generate({
  bindto: '#donut-chart',
  data: {
    type: 'donut',
    columns: gon.global.totals,
    colors: gon.global.colors
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
