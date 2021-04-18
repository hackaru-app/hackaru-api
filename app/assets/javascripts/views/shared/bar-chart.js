import c3 from 'c3/c3.esm';
import 'd3-array';
import 'd3-brush';
import 'd3-collection';
import 'd3-color';
import 'd3-dispatch';
import 'd3-ease';
import 'd3-format';
import 'd3-interpolate';
import 'd3-path';
import 'd3-scale-chromatic';
import 'd3-scale';
import 'd3-selection';
import 'd3-shape';
import 'd3-time-format';
import 'd3-timer';
import 'd3-transition';
import 'd3-zoom';

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
