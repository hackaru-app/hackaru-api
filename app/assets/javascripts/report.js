
function generateDonut() {
  const element = document.getElementById('donut-chart');
  const chart = JSON.parse(element.dataset.chart);

  c3.generate({
    bindto: '#donut-chart',
    data: {
      type : 'donut',
      ...chart
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
  const chart = JSON.parse(element.dataset.chart);
  const categories = JSON.parse(element.dataset.categories);

  c3.generate({
    bindto: '#bar-chart',
    data: {
      type: 'bar',
      ...chart
    },
    legend: {
      show: false
    },
    axis: {
      x: {
        type: 'category',
        categories: categories
      }
    }
  });
}

generateBarChart();
generateDonut();