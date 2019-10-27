
function generateDonut() {
  const element = document.getElementById('donut-chart');
  const columns = JSON.parse(element.dataset.columns);
  const colors = JSON.parse(element.dataset.colors);

  c3.generate({
    bindto: '#donut-chart',
    data: {
      type : 'donut',
      columns: columns,
      colors: colors
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
}

function generateBarChart() {
  const element = document.getElementById('bar-chart');
  const columns = JSON.parse(element.dataset.columns);
  const colors = JSON.parse(element.dataset.colors);
  const labels = JSON.parse(element.dataset.labels);

  c3.generate({
    bindto: '#bar-chart',
    data: {
      type: 'bar',
      columns: columns,
      colors: colors
    },
    legend: {
      show: false
    },
    axis: {
      x: {
        type: 'category',
        categories: labels
      }
    }
  });
}

generateBarChart();
generateDonut();