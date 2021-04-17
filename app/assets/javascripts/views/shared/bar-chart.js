import c3 from 'c3';
import 'd3';

function getTickFormat(seconds) {
  const hours = seconds / 3600;
  return hours % 0.5 === 0 ? `${hours}h` : '';
}

const data = JSON.parse(document.getElementById('bar-chart').dataset.json);

c3.generate({
  bindto: '#bar-chart',
  data: {
    type: 'bar',
    columns: data.bar_chart_data,
    colors: data.colors,
    groups: [data.groups],
  },
  legend: {
    show: false,
  },
  axis: {
    x: {
      type: 'category',
      categories: data.labels,
    },
    y: {
      tick: {
        format: getTickFormat,
      },
    },
  },
});
