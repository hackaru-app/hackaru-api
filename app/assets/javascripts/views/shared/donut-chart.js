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

const data = JSON.parse(document.getElementById('donut-chart').dataset.json);

c3.generate({
  bindto: '#donut-chart',
  data: {
    type: 'donut',
    columns: data.totals,
    colors: data.colors,
  },
  donut: {
    label: {
      show: false,
    },
  },
  legend: {
    show: false,
  },
});
