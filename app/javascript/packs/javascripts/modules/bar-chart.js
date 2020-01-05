import c3 from 'c3';
import 'd3';

function getTickFormat(seconds) {
  const hours = seconds / 3600;
  return hours % 0.5 === 0 ? `${hours}h` : '';
}

export function renderBarChart(options) {
  c3.generate({
    bindto: '#bar-chart',
    data: {
      type: 'bar',
      columns: options.bar_chart_data,
      colors: options.colors,
      groups: [options.groups]
    },
    legend: {
      show: false
    },
    axis: {
      x: {
        type: 'category',
        categories: options.labels
      },
      y: {
        tick: {
          format: getTickFormat
        }
      }
    }
  });
}
