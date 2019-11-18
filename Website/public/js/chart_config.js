//SRC: https://tobiasahlin.com/blog/chartjs-charts-to-get-you-started/
//Library: https://www.chartjs.org/samples/latest/


var ctx = document.getElementById('exHis').getContext('2d');
var myChart = new Chart(ctx, {
  type: 'line',
  data: {
    labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
    datasets: [{
      label: 'Flexibility',
      data: [12, 2, 9, 17, 6, 3, 7],
      backgroundColor: "rgba(153,255,51,0.4)"
    }, {
      label: 'Strength',
      data: [2, 1, 5, 5, 2, 3, 10],
      backgroundColor: "rgba(255,153,0,0.4)"
    }, {
      label: 'Balance',
      data: [9, 3, 4, 2, 13, 4, 2],
      backgroundColor: "rgba(45,32,0,0.4)"
    }, {
      label: 'Cardio',
      data: [1, 2, 7, 5, 3, 5, 10],
      backgroundColor: "rgba(153,255,0,0.4)"
    }]
  }
});


new Chart(document.getElementById("trendsChart"), {
    type: 'pie',
    data: {
      labels: ["Flexibility", "Strength", "Cardio", "Balance"],
      datasets: [{
        label: "Number of Exercise",
        backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
        data: [2478,5267,734,784]
      }]
    },
    options: {
      title: {
				responsive: true,
				maintainAspectRatio: false,
        display: true,
        text: 'Percentage of Exercises Done by Category'
      }
    }
});



var ctx = document.getElementById('stepCountChart');
//ctx.canvas.width = 300;
//ctx.canvas.height = 300;
new Chart((ctx), {
    type: 'bar',
    data: {
      labels: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday","Saturday","Sunday"],
      datasets: [
        {
          label: "Steps taken",
          backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850","#B22222","#32CD32"],
          data: [2478,3267,2134,7384,4433,1221,900]
        }
      ]
    },
    options: {
			responsive: true,
			maintainAspectRatio: false,
      legend: { display: false },
      title: {
        display: true,
        text: 'Step Counter over the past Week!'
      }
    }
});
/*
var myChart = new Chart(ctx, {
	type: 'bar',
	data: {
			labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
			datasets: [{
					label: 'Number of Steps',
					data: [11, 19, 3, 5, 2, 3, 20],
					backgroundColor: [
							'rgba(255, 99, 132, 0.2)',
							'rgba(54, 162, 235, 0.2)',
							'rgba(255, 206, 86, 0.2)',
							'rgba(75, 192, 192, 0.2)',
							'rgba(153, 102, 255, 0.2)',
							'rgba(255, 159, 64, 0.2)',
							'rgba(255, 120, 29, 0.2)'
					],
					borderColor: [
							'rgba(255, 99, 132, 1)',
							'rgba(54, 162, 235, 1)',
							'rgba(255, 206, 86, 1)',
							'rgba(75, 192, 192, 1)',
							'rgba(153, 102, 255, 1)',
							'rgba(255, 159, 64, 1)',
							'rgba(255, 120, 29, 1)'
					],
					borderWidth: 1
			}]
	},
	options: {
			scales: {
					yAxes: [{
							ticks: {
									beginAtZero: true
							}
					}]
			}
	}
});
*/

