function validateInput(){
	var tb = document.forms["inputform"]["tb"].value;
	var bb = document.forms["inputform"]["bb"].value;
	var usia = document.forms["inputform"]["usia"].value;
	var jk = document.forms["inputform"]["jk"].value;
	if (!((jk == "Laki-laki" && (66 + 13.7*bb + 5*tb - 6.8*usia) > 500) || 
			(jk == "Perempuan" && (655 + 9.6*bb + 1.8*tb - 4.7*usia) > 500))){
		alert("Masukan tidak valid. Coba masukan lain.");
		return false;
	}
}

function printWaktu(waktu){
	var out = '';
	switch(waktu){
		case 1:
			out = "Menu Pagi"; break;
		case 2:
			out = "Menu Siang"; break;
		case 3:
			out = "Menu Malam"; break;
		case 4:
			out = "Snack Pagi (10.00)"; break;
		case 5:
			out = "Snack Sore (16.00)"; break;
	}
	return out;
}

function printoutMenu(menu, waktu){
	var out = '';
	if(waktu == 1 || waktu == 2 || waktu == 4)
		out += '<div class="col-md-4 result2">';
	else
		out += '<div class="col-md-4">';
	out += '<div class="pa--heading3">' + printWaktu(waktu) + '</div><ul>';
	for(var i in menu){
		out += '<li>' + menu[i] + '</li>';
	}
	out += '</ul></div>';
	return out;
}

$('#menu').submit(function(){
	var pagi = [], siang = [], malam = [], snackPagi = [], snackSore = [];
	var check = true;

	var golongan = [1, 2, 3, 'A', 4, 5, 6, 7];
	for(var i in golongan){
		var idPagi = '#pagi-' + golongan[i];
		var idSiang = '#siang-' + golongan[i];
		var idMalam = '#malam-' + golongan[i];
		var idSnackPagi = '#snack-pagi-' + golongan[i];
		var idSnackSore = '#snack-sore-' + golongan[i];
		if($(idPagi)[0] && check){
			if($(idPagi).val() != '')
				pagi.push($(idPagi).val());
			else
				check = false;
		}
		if($(idSiang)[0] && check){
			if($(idSiang).val() != '')
				siang.push($(idSiang).val());
			else
				check = false;
		}
		if($(idMalam)[0] && check){
			if($(idMalam).val() != '')
				malam.push($(idMalam).val());
			else
				check = false;
		}
		if($(idSnackPagi)[0] && check){
			if($(idSnackPagi).val() != '')
				snackPagi.push($(idSnackPagi).val());
			else
				check = false;
		}
		if($(idSnackSore)[0] && check){
			if($(idSnackSore).val() != '')
				snackSore.push($(idSnackSore).val());
			else
				check = false;
		}
	}
	if(check){
		var out = '<div class="pa--heading">Menu Makanan yang Dipilih</div>' +
		'<div class="row">';
		out += printoutMenu(pagi,1) + printoutMenu(siang,2)
				+ printoutMenu(malam,3);
		out += '</div>' + '<div class="row">';
		out += printoutMenu(snackPagi,4) + printoutMenu(snackSore,5);
		out += '</div>';
		out += '<form class="col-md-8 pa__btn-container-form">' +
			'<input type="button" onClick="history.go(0)"' + 
			'class="btn btn-tosca btn-margin-bottom" value="Pilih menu lain"></input></form><br><br><br>';
		$(this).replaceWith(out);
	} else
		alert("Masih ada bahan makanan yang belum dipilih. Pilihlah semua bahan makanan.");
	return false;
});
