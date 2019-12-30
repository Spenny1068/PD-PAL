//SRC: https://tobiasahlin.com/blog/chartjs-charts-to-get-you-started/
//Library: https://www.chartjs.org/samples/latest/

//set the exercise history chart
//input: la_a, la_b, la_c, la_d, la_e, la_f, la_g //the 7 label strings
//input: flex_a, flex_b, flex_c, flex_d, flex_e, flex_f // 7 data points for flexibilty
//input: stre_a, stre_b, stre_c, stre_d, stre_e, stre_f //7 data points for strengh
//input: bala_a, bala_b, bala_c, bala_d, bala_e, bala_f //7 data points for balance
//input: card_a, card_b, card_c, card_d, card_e, card_f //7 data points for cardio
function set_exercise_history
(
	la_a, la_b, la_c, la_d, la_e, la_f, la_g,
	flex_a, flex_b, flex_c, flex_d, flex_e, flex_f, flex_g,
	stre_a, stre_b, stre_c, stre_d, stre_e, stre_f, stre_g,
	card_a, card_b, card_c, card_d, card_e, card_f, card_g,
	bala_a, bala_b, bala_c, bala_d, bala_e, bala_f, bala_g,
)
{
	var ctx = document.getElementById('exHis');
	ctx.remove();
	$('#History').append('<canvas id="exHis"> </canvas>');
	var ctx = document.getElementById('exHis').getContext('2d');



	var myChart = new Chart(ctx, {
		type: 'line',
		data: {
			labels: [la_a, la_b, la_c, la_d, la_e, la_f, la_g],
			datasets: [{
				label: 'Flexibility',
				data: [flex_a, flex_b, flex_c, flex_d, flex_e, flex_f, flex_g],
				backgroundColor: "rgba(153,255,51,0.4)"
			}, {
				label: 'Strength',
				data: [stre_a, stre_b, stre_c, stre_d, stre_e, stre_f, stre_g],
				backgroundColor: "rgba(255,153,0,0.4)"
			}, {
				label: 'Cardio',
				data: [card_a, card_b, card_c, card_d, card_e, card_f, card_g],
				backgroundColor: "rgba(45,32,0,0.4)"
			}, {
				label: 'Balance',
				data: [bala_a, bala_b, bala_c, bala_d, bala_e, bala_f, bala_g],
				backgroundColor: "rgba(153,255,0,0.4)"
			}]
		},
		options: {
			responsive: true,
			maintainAspectRatio: false,
			legend: { display: false },
			title: {
				display: true,
				text: 'Recent Exercise Distribution Over Selected Interval!'
			},
			scales: 
			{
				yAxes: 
				[{
					ticks: 
					{
						beginAtZero: true
					}
				}]
			}
		}
	});
}




//set the trendsChart
//input: la_a, la_b, la_c, la_d //the 4 labels
//input: da_a, da_b, da_c, da_d //the 4 data values
function set_trends(la_a, la_b, la_c, la_d, da_a, da_b, da_c, da_d){

	var ctx = document.getElementById('trendsChart');
	ctx.remove();
	$('#Trends').append('<canvas id="trendsChart" width="800" height="450"></canvas>');
	var ctx = document.getElementById('trendsChart');

	new Chart(ctx, {
			type: 'pie',
			data: {
				labels: [la_a, la_b, la_c, la_d],
				datasets: [{
					label: "Number of Exercise",
					backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9"],
					data: [ da_a, da_b, da_c, da_d]
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
}



//set the stepCount chart
//input: la_a, la_b, la_c, la_d, la_e, la_f, la_g //the 7 label strings
//input: da_a, da_b, da_c, da_d, da_e, da_f, da_g //the 7 data values
function set_stepcount(la_a, la_b, la_c, la_d, la_e, la_f, la_g, da_a, da_b, da_c, da_d, da_e, da_f, da_g){

	var ctx = document.getElementById('stepCountChart');
	ctx.remove();
	$('#Steps').append('<canvas id="stepCountChart" height=200 width=200></canvas>');
	var ctx = document.getElementById('stepCountChart');

	//ctx.canvas.width = 300;
	//ctx.canvas.height = 300;
	new Chart((ctx), {
			type: 'bar',
			data: {
				labels: [la_a, la_b, la_c, la_d, la_e, la_f, la_g],
				datasets: [
					{
						label: "Steps taken",
						backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850","#B22222","#32CD32"],
						data: [da_a, da_b, da_c, da_d, da_e, da_f, da_g]
					}
				]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				legend: { display: false },
				title: {
					display: true,
					text: 'Step Counter over the selected time interval!'
				},
				scales: 
				{
					yAxes: 
					[{
						ticks: 
						{
							beginAtZero: true
						}
					}]
				}
			}
	});
}


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

