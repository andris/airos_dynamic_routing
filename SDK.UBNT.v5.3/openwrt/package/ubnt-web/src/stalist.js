var mainTable;
var _cols = {
	mac: 0,
	name: 1,
	signal: 2,
	ack: 3,
	txrx: 4,
	ccq: 5,
	uptime: 6,
	ip: 7,
	action: 8,
	rate_count: 9,
	apwds: 10
};

function handleError(xhr, textStatus, errorThrown) {
	if (xhr && xhr.status != 200 && xhr.status != 0)
		window.location.reload();
}

function kickEnd(data, textStatus, xhr) {
	$(this).enable();
	refreshStaList();
}

function kickStation(a, ifname, hwaddr) {
	$(a).parent().parent('tr').hide();
	var kick_url = '/stakick.cgi?staif=' + ifname + '&staid=' + hwaddr;
	jQuery.ajax({
		url: kick_url,
		cache: false,
		dataType: "json",
		success: kickEnd,
		error: handleError
	});
	return false;
}

function refreshStaList() {
	$.ajax({
		cache: false,
		url: '/sta.cgi',
		dataType: 'json',
		success: showStaList,
		error: handleError
	});
}

function refreshAll() {
	if (typeof reloadStatus == 'function')
		reloadStatus();
	refreshStaList();
}

function getStaInfo(sta) {
	var result = [
		sta.mac,
		sta.name,
		sta.signal + ' / ' + sta.noisefloor,
		sl_global.autoack ? (sta.ack > 0 ? sta.ack : sl_global.ack) : 0,
		sta.tx + ' / ' + sta.rx,
		sta.ccq,
		sta.uptime,
		sta.lastip,
		0,
		sta.rates.length,
		sta.apwds];
		
	return result;
}

function showStaList(sl) {
	mainTable.fnClearTable();
	for (var i = 0; i < sl.length; ++i) {
		var sta = sl[i];
		var id = sta.mac.replace(/:/g, '');
		var idx = mainTable.fnAddData(getStaInfo(sta), true);
	}
}

function tableCell(ctx, col) {
	var idx = mainTable.oApi._fnColumnIndexToVisible(mainTable.fnSettings(), col);
	if (idx == null)
		return $();
	return $('td', ctx).eq(idx);
}

function updateMac(row, data) {
	var height = data[_cols.rate_count] > 8 ? 520 : 400;

	var open_page = 'openPage(\'stainfo.cgi?ifname=' + sl_global.wlan_iface;
	open_page += '&sta_mac=' + data[_cols.mac] + '\', 700, ' + height + ');';

	var mac_html = '<a href="#" onClick="' + open_page + '">' + data[_cols.mac] + '</a>';
	mac_html += ((data[_cols.apwds] == 0) ? '' : '&nbsp;(' + $.l10n._('AP-WDS') + ')')
	mac_html += '&nbsp;&nbsp;&nbsp;';

	tableCell(row, _cols.mac).html(mac_html);
}

function updateName(row, data) {
	if (data[_cols.name].length > 0)
		tableCell(row, _cols.name).text(data[_cols.name]);
	else
		tableCell(row, _cols.name).html('&nbsp;');
}

function updateCcq(row, data) {
	if (data[_cols.ccq] <= 0)
		tableCell(row, _cols.ccq).text('-');
}

function updateUptime(row, data) {
	var uptime = secsToCountdown(data[_cols.uptime], $.l10n._('day'), $.l10n._('days'));
	tableCell(row, _cols.uptime).text(uptime);
}

function updateIp(row, data) {
	var lastip = data[_cols.ip] != '0.0.0.0' ? 
		'<a href="http://' + data[_cols.ip] + '" target="_blank">' + data[_cols.ip] + '</a>' :
		$.l10n._('unknown');
	tableCell(row, _cols.ip).html(lastip);
}

function updateAction(row, data) {
	var kick_str = '&nbsp;';
	if (data[_cols.apwds] == 0)
		kick_str = '<a href="#" onClick="return kickStation(this, \'' +
			sl_global.wlan_iface + '\', \'' + data[_cols.mac] + '\');">kick</a>';
	tableCell(row, _cols.action).html(kick_str);
}

function updateRow(row, data, idx, idx_full) {
	updateMac(row, data);
	updateName(row, data);
	updateCcq(row, data);
	updateUptime(row, data);
	updateIp(row, data);
	updateAction(row, data);
	return row;
}

$(document).ready(function() {
	$.l10n.init({ dictionary: l10n_stalist });
	$('#_refresh').click(refreshAll);

	mainTable = $('#sta_list').dataTable({
		'aaSorting': [ [1,'asc'] ],
		'bLengthChange': false,
		'bPaginate': false,
		'bFilter': false,
		'bInfo': false,
		'bSortClasses': false,
		'bAutoWidth': true,
		'oLanguage': {
			'sEmptyTable': $.l10n._('Loading, please wait...')
		},
		'fnRowCallback': updateRow,
		'fnInitComplete': function (oSettings) {
			oSettings.oLanguage.sEmptyTable = $.l10n._('No Associated Stations');
		},
		'aoColumnDefs': [
			{ 'sClass': 'centered', 'aTargets': [ _cols.signal, _cols.ack, _cols.txrx, _cols.ccq, _cols.action ] },
			{ 'sClass': 'uptime', 'aTargets': [ _cols.uptime ] },
			{ 'bSortable': false, 'aTargets': [ _cols.action ] },
			{ 'bVisible': false, 'aTargets': [ _cols.rate_count, _cols.apwds ] },
			{ 'bVisible': sl_global.autoack, 'aTargets': [ _cols.ack ] },
			{ 'sType': 'rate', 'aTargets': [ _cols.txrx ] },
			{ 'sType': 'signal', 'aTargets': [ _cols.signal ] }
		]
	});

	refreshStaList();
});

$.fn.dataTableExt.aTypes.push(
	function (data) {
		if (/^\d{1,3}[\.]\d{1,3}[\.]\d{1,3}[\.]\d{1,3}$/.test(data))
			return 'ip-address';
		return null;
	}
);

$.fn.dataTableExt.oApi.fnSortByIp = function(ip1, ip2, asc) {
	var l = ip1.split('.');
	var r = ip2.split('.');
	var ret = asc ? -1 : 1;

	for (var i = 0; i < l.length && i < r.length; ++i) {
		var left = parseInt(l[i]), right = parseInt(r[i]);
		if (left != right)
			return ((left < right) ? ret : -ret);
	}
	return 0;
}

$.fn.dataTableExt.oSort['ip-address-asc'] = function(a, b) {
	return $.fn.dataTableExt.oApi.fnSortByIp(a, b, true);
};

$.fn.dataTableExt.oSort['ip-address-desc'] = function(a, b) {
	return $.fn.dataTableExt.oApi.fnSortByIp(a, b, false);
};


$.fn.dataTableExt.oApi.fnSortByRate = function(r1, r2, asc) {
	var l = r1.split(/\s+/);
	var r = r2.split(/\s+/);
	var ret = asc ? -1 : 1;
	for (var i = 0; i < l.length && i < r.length; ++i) {
		var left = Number(l[i]);
		if (isNaN(left)) left = 0;
		var right = Number(r[i]);
		if (isNaN(right)) right = 0;
		if (left != right)
			return ((left < right) ? ret : -ret);
	}
	return 0;
}

$.fn.dataTableExt.oSort['rate-asc'] = function(a, b) {
	return $.fn.dataTableExt.oApi.fnSortByRate(a, b, true);
};

$.fn.dataTableExt.oSort['rate-desc'] = function(a, b) {
	return $.fn.dataTableExt.oApi.fnSortByRate(a, b, false);
};

$.fn.dataTableExt.oSort['signal-asc'] = function(a, b) {
	return $.fn.dataTableExt.oApi.fnSortByRate(a, b, true);
};

$.fn.dataTableExt.oSort['signal-desc'] = function(a, b) {
	return $.fn.dataTableExt.oApi.fnSortByRate(a, b, false);
};

