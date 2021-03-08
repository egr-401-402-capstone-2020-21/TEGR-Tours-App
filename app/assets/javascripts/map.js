$(document).ready(function(){
	var map1 = document.getElementById('map');
	var floor1 = document.getElementById('floor1');
	var floor2 = document.getElementById('floor2');
	var floor3 = document.getElementById('floor3');
	floor1.addEventListener('click', function() {
		map.src = 'assets/TEGR_Floor1.jpg';
	});
	floor2.addEventListener('click', function() {
		map.src = 'assets/TEGR_Floor2.jpg';
	});
	floor3.addEventListener('click', function() {
		map.src = 'assets/TEGR_Floor3.jpg';
	});
});
