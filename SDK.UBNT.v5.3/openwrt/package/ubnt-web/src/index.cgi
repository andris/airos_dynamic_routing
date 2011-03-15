#!/sbin/cgi
<?
include("lib/settings.inc");
$cfg = @cfg_load($cfg_file_bak);
include("lib/l10n.inc");
include("lib/link.inc");

$chain1_name = dict_translate("Chain 0");
$chain2_name = dict_translate("Chain 1");

/* Chain/Anntenna names for NANO2/5N and LOCO2N*/
if ($radio1_subsystemid == "0xe012" || $radio1_subsystemid == "0xe005"
	|| $radio1_subsystemid == "0xe0a2")
{
	$chain1_name = dict_translate("Horizontal");
	$chain2_name = dict_translate("Vertical");
}
/* Chain/Anntenna names LOCO5N */
elseif ($radio1_subsystemid == "0xe0a5")
{
	$chain1_name = dict_translate("Vertical");
	$chain2_name = dict_translate("Horizontal");
}

$wmode = cfg_get_wmode($cfg, $wlan_iface);
$security = cfg_get_security($cfg, $wlan_iface, $security, $wmode);

if (!($radio1_caps & $radio_cap_11n_no_ht40))
{
	$radio_has_ht40 = "true";
}
else
{
	$radio_has_ht40 = "false";
}

if ($radio_outdoor == 0 && !isset($advmode_status)) {
	$cfg_new = @cfg_load($cfg_file);
	$advmode_status = cfg_get_def($cfg_new, "system.advanced.mode", "disabled");
}

>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><? echo get_title($cfg, dict_translate("Main")); ></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="SKYPE_TOOLBAR" content="SKYPE_TOOLBAR_PARSER_COMPATIBLE" />
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<link rel="shortcut icon" href="FULL_VERSION_LINK/favicon.ico" >
<link href="FULL_VERSION_LINK/style.css" rel="stylesheet" type="text/css">
<script type="text/javascript" language="javascript" src="FULL_VERSION_LINK/signal.js"></script>
<script type="text/javascript" language="javascript" src="FULL_VERSION_LINK/util.js"></script>
<script type="text/javascript" language="javascript" src="FULL_VERSION_LINK/index.js"></script>
<script type="text/javascript" src="FULL_VERSION_LINK/js/jquery.js"></script>
<? flush(); >
<script type="text/javascript" language="javascript">
//<!--
var status_reload_interval = 0;
var global = {
	'wlan_iface': "<? echo $wlan_iface;>",
	'chain_count': "<? echo $radio1_chains; >",
	'security': "<? echo $security; >",
	'has_ht40' : <? echo $radio_has_ht40; >,
	'is_3g_product' : <? if ($feature_3g == 1) { echo "true"; } else { echo "false"; } >,
	'_': '_'
};
var l10n_lang = {
	'Access Point WDS': "<? echo dict_translate("Access Point WDS");>",
	'Access Point': "<? echo dict_translate("Access Point");>",
	'Station WDS': "<? echo dict_translate("Station WDS");>",
	'Station': "<? echo dict_translate("Station");>",
	'Spectral Analyzer': "<? echo dict_translate("Spectral Analyzer");>",
	'Active': "<? echo dict_translate("Active");>",
	'clients': "<? echo dict_translate("clients");>",
	'Idle for': "<? echo dict_translate("Idle for");>",
	'Back to': "<? echo dict_translate("Back to");>",
	'Switching back to': "<? echo dict_translate("Switching back to");>",
	'in': "<? echo dict_translate("in");>",
	's': "<? echo dict_translate("s");>",

	'Bridge': "<? echo dict_translate("Bridge");>",
	'Router': "<? echo dict_translate("Router");>",
	'SOHO Router': "<? echo dict_translate("SOHO Router");>",
	'3G Router': "<? echo dict_translate("3G Router");>",

	'Auto': "<? echo dict_translate("Auto");>",
	'Lower': "<? echo dict_translate("Lower");>",
	'Upper': "<? echo dict_translate("Upper");>",
	'Enabled': "<? echo dict_translate("Enabled");>",
	'Disabled': "<? echo dict_translate("Disabled");>",
	'Not Associated': "<? echo dict_translate("Not Associated");>",
	'Hidden SSID:': "<? echo dict_translate("Hidden SSID:");>",

	'wep': '<? echo dict_translate("WEP"); >',
	'wpa': '<? echo dict_translate("WPA"); >',
	'wpatkip': '<? echo dict_translate("WPA-TKIP"); >',
	'wpaaes': '<? echo dict_translate("WPA-AES"); >',
	'wpa2': '<? echo dict_translate("WPA2"); >',
	'wpa2tkip': '<? echo dict_translate("WPA2-TKIP"); >',
	'wpa2aes': '<? echo dict_translate("WPA2-AES"); >',
	'none': '<? echo dict_translate("none"); >',

	'day': '<? echo dict_translate("day"); >',
	'days': '<? echo dict_translate("days"); >',
	/* cable status */
	'Plugged': '<? echo dict_translate("Plugged"); >',
	'Unplugged': '<? echo dict_translate("Unplugged"); >',
	'Full': '<? echo dict_translate("Full"); >',
	'Half': '<? echo dict_translate("Half"); >',
	/* antennas */
	'Unknown': "<? echo dict_translate("Unknown"); >",
	'Main': "<? echo dict_translate("Main"); >",
	'Combined': "<? echo dict_translate("Combined"); >",
	'Secondary': "<? echo dict_translate("Secondary"); >",
	'Diversity': "<? echo dict_translate("Diversity"); >",
	'Vertical': "<? echo dict_translate("Vertical"); >",
	'Horizontal': "<? echo dict_translate("Horizontal"); >",
	'Adaptive': "<? echo dict_translate("Adaptive"); >",
	'External': "<? echo dict_translate("External"); >",
	'Internal': "<? echo dict_translate("Internal"); >",
	'Internal + External': "<? echo dict_translate("Internal + External"); >",
	'Antenna 1': "<? echo dict_translate("Antenna 1"); >",
	'Antenna 2': "<? echo dict_translate("Antenna 2"); >",
	'Antenna 2': "<? echo dict_translate("Antenna 2"); >",
	'Not detected': "<? echo dict_translate("Not detected"); >",
	'Please insert SIM card': "<? echo dict_translate("Please insert SIM card"); >",
	'SIM PIN required': "<? echo dict_translate("SIM PIN required"); >",
	'SIM Card Blocked': "<? echo dict_translate("SIM Card Blocked"); >",

	'_': '_' /* end marker */
};

function l10n_get(w) {
	var t = l10n_lang[w];
	if (t)
		return t;
	if (window.console && window.console.log)
		window.console.log('L10N ERROR: untranslated "' + w + '"');
	return w;
}

function init() {
	$('#noscript').remove();
	$('#extrainfo span').addClass('initial_hide');
	$('#signalinfo').hide();
<? if ($radio1_antennas != 1) { ?>
	$('#antennainfo').hide();
<?}>
	reloadStatus();

	$('#extrainfo a').click( function(){
			$('#extrainfo a').removeClass('underline');
			$(this).addClass('underline');
			refreshContent($(this).attr('href'));
			return false;
	});

	$('#extrainfo span.all').removeClass('initial_hide');
	$('#extrainfo a:first').trigger('click');
}

$(document).ready(init);
//-->
</script>
</head>
<? flush(); >
<body>
<table class="maintable" cellpadding="0" align="center" cellspacing="0"><?
$top_tab = "main"; include("lib/head.tmpl");
>  <tr>
<td colspan="2" class="centr">
<noscript id="noscript"><? echo dict_translate("warn_no_script|You have disabled JavaScript in your browser, but the functionality of this page depends on it. Please, enable JavaScript and refresh this page."); >
</noscript>

<br>
	<table border="0" cellpadding="0" cellspacing="0" class="linktable">
	  <tr><th colspan="2"><? echo dict_translate("Status"); ></th></tr>
	  <tr><td valign="top" style="width: 45%">
		<div class="fieldset" id="general_info">
		  <div id="hostinfo" class="row">
			<span class="label"><? echo dict_translate("Device Name:"); ></span>
			<span class="value" id="hostname">&nbsp;</span>
		  </div>
		  <div id="netmodeinfo" class="row">
			<span class="label"><? echo dict_translate("Network Mode:"); ></span>
			<span class="value" id="netmode">&nbsp;</span>
		  </div>
		  <div id="wmodeinfo" class="row">
			<span class="label"><? echo dict_translate("Wireless Mode:"); ></span>
			<span class="value" id="wmode">&nbsp;</span>
		  </div>
		  <div id="astatusinfo" class="row">
			<span class="label"><? echo dict_translate("AirView Status:"); ></span>
			<span class="value" id="astatus">&nbsp;</span>
		  </div>
		  <div id="ssidinfo" class="row">
			<span class="label" id="essid_label"><? echo dict_translate("SSID:"); ></span>
			<span class="value" id="essid">&nbsp;</span>
		  </div>
		  <div id="securityinfo" class="row">
			<span class="label"><? echo dict_translate("Security:"); ></span>
			<span class="value" id="security">&nbsp;</span>
		  </div>
		  <div id="fwversioninfo" class="row">
			<span class="label"><? echo dict_translate("Version:"); ></span>
			<span class="value" id="fwversion">&nbsp;</span>
		  </div>
		  <div id="uptimeinfo" class="row">
			<span class="label"><? echo dict_translate("Uptime:"); ></span>
			<span class="value" id="uptime">&nbsp;</span>
		  </div>
		  <div id="dateinfo" class="row">
			<span class="label"><? echo dict_translate("Date:"); ></span>
			<span class="value" id="date">&nbsp;</span>
		  </div>
		</div>

		<div class="fieldset" id="radioinfo">
		  <div id="freqinfo" class="row">
			<span class="label"><? echo dict_translate("Channel/Frequency:"); ></span>
			<span class="value">
			  <span id="channel">&nbsp;</span>
			  <span>&nbsp;/&nbsp;</span>
			  <span id="frequency">&nbsp;</span>
			</span>
		  </div>
		  <div id="chanwidthinfo" class="row">
			<span class="label"><? echo dict_translate("Channel Width:"); ></span>
			<span class="value">
			  <span id="wd">&nbsp;</span>
			  <span id="ext_chan"></span>
			</span>
		  </div>
		  <div id="ackinfo" class="row">
			<span class="label"><? echo dict_translate("ACK/Distance:"); ></span>
			<span class="value" id="ack">&nbsp;</span>
		  </div>
		  <div id="chainsinfo" class="row">
			<span class="label"><? echo dict_translate("TX/RX Chains:"); ></span>
			<span class="value" id="chains">&nbsp;</span>
		  </div>
		  <div id="antennainfo" class="row">
			<span class="label"><? echo dict_translate("Antenna:"); ></span>
			<span class="value" id="antenna">&nbsp;</span>
		  </div>
		</div>

		<div class="fieldset" id="macinfo">
		  <div id="wlanmac"  class="row">
			<span class="label"><? echo dict_translate("WLAN MAC:"); ></span>
			<span class="value" id="w_mac">&nbsp;</span>
		  </div>
		  <div id="lanmac"  class="row">
			<span class="label"><? echo dict_translate("LAN MAC:"); ></span>
			<span class="value" id="l_mac">&nbsp;</span>
		  </div>
		  <div id="wanmac"  class="row router">
			<span class="label"><? echo dict_translate("WAN MAC:"); ></span>
			<span class="value" id="wan_mac">&nbsp;</span>
		  </div>
		  <div id="lancableinfo" class="row oneport">
			<span class="label" id="lan_label"><? echo dict_translate("LAN:"); ></span>
			<span class="label" id="wan_label"><? echo dict_translate("WAN:"); ></span>
			<span class="value oneport" id="lan_cable">&nbsp;</span>
		  </div>
		  <div id="lan2cableinfo" class="row twoport">
			<span class="label" id="lan2_label"><? echo dict_translate("LAN1/LAN2:"); ></span>
			<span class="label" id="wanlan_label"><? echo dict_translate("WAN/LAN:"); ></span>
			<span class="value">
			  <span id="lan1_cable">&nbsp;</span>
			  <span>&nbsp;/&nbsp;</span>
			  <span id="lan2_cable">&nbsp;</span>
			</span>
		  </div>
		</div>
	  </td>
	  <td valign="top">
		<div class="fieldset" id="cinfo">
		  <div id="apmacinfo" class="row">
			<span class="label"><? echo dict_translate("AP MAC:"); ></span>
			<span class="value" id="apmac">&nbsp;</span>
		  </div>
		  <div id="signalinfo" class="row stainfo">
			<span class="label"><? echo dict_translate("Signal Strength:"); ></span>
			<span class="value">
			  <span class="percentborder switchable"><div id="signalbar" class="mainbar">&nbsp;</div></span>
			  <span class="switchable">&nbsp;</span>
			  <span id="signal"></span>
			</span>
		  </div>
		  <div id="signal_chain" class="row initial_hide">
			<span class="label"><? echo $chain1_name; >&nbsp;/&nbsp;<? echo $chain2_name; >:</span>
			<span class="value">
			 <span id="signal_0">&nbsp;</span>
			 <span>&nbsp;/&nbsp;</span>
			 <span id="signal_1">&nbsp;</span>
			 <span>&nbsp;dBm</span>
			</span>
		  </div>
		  <div id="coninfo" class="row apinfo">
			<span class="label"><? echo dict_translate("Connections:"); ></span>
			<span class="value" id="count">&nbsp;</span>
		  </div>
		  <div id="nfinfo" class="row">
			<span class="label"><? echo dict_translate("Noise Floor:"); ></span>
			<span class="value">
			  <span id="noisef"></span>
			</span>
		  </div>
		  <div id="ccqinfo" class="row">
			<span class="label"><? echo dict_translate("Transmit CCQ:"); ></span>
			<span class="value">
			  <span id="ccq">&nbsp;</span>
			  <span>&nbsp;</span>
			</span>
		  </div>
		  <div id="rateinfo" class="row stainfo">
	        <span class="label"><? echo dict_translate("TX/RX Rate:"); ></span>
			<span class="value">
			  <span id="txrate">&nbsp;</span>
			  <span>&nbsp;/&nbsp;</span>
			  <span id="rxrate">&nbsp;</span>
			</span>
		  </div>
		</div>
		<div class="fieldset" id="pollinfo">
		  <div id="pollstatusinfo" class="row">
			<span class="label"><? echo dict_translate("AirMax:"); ></span>
			<span class="value" id="polling">&nbsp;</span>
		  </div>
		  <div id="amqinfo" class="row pollinfo initial_hide">
			<span class="label"><? echo dict_translate("AirMax Quality:"); ></span>
			<span class="value">
			  <span class="percentborder"><div id="amqbar" class="mainbar">&nbsp;</div></span>
			  <span>&nbsp;</span>
			  <span id="amq">&nbsp;</span>
			  <span>&nbsp;%</span>
			</span>
		  </div>
		  <div id="amcinfo" class="row pollinfo initial_hide">
	        <span class="label"><? echo dict_translate("AirMax Capacity:"); ></span>
	        <span class="value">
			  <span id="amcborder" class="percentborder"><div id="amcbar" class="mainbar">&nbsp;</div></span>
			  <span>&nbsp;</span>
			  <span id="amc">&nbsp;</span>
			  <span>&nbsp;%</span>
			</span>
		  </div>
		</div>
		<div class="fieldset initial_hide" id="ipinfo">
		  <div id="wan_ip_row" class="row">
			<span class="label"><? echo dict_translate("WLAN IP Address:"); ></span>
			<span class="value" id="wlan_ip">&nbsp;</span>
		  </div>
		  <div id="lan_ip_row" class="row">
			<span class="label"><? echo dict_translate("LAN IP Address:"); ></span>
			<span class="value" id="lan_ip">&nbsp;</span>
		  </div>
		</div>
		<? if ($board_netmodes & $netmode_3g) { >
		<div class="fieldset"/>
		<div id="threeg_info" class="fieldset initial_hide">
			<div class="row">
				<span class="label"><? echo dict_translate("Cellular Device:"); ></span>
				<span class="value" id="threeg_product"></span>
			</div>
			<div id="threeg_status_row" class="row initial_hide">
				<span class="label"></span>
				<span class="value" id="threeg_status"></span>
			</div>
			<div id="threeg_signal_row" class="row initial_hide">
				<span class="label"><? echo dict_translate("Cellular Signal Strength:"); ></span>
				<span class="value">
					<span class="percentborder"><div id="threeg_bar" class="mainbar">&nbsp;</div></span>
					<span >&nbsp;</span>
				</span>
			</div>
		</div>
		<? } >
	   </td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><th colspan="2"><? echo dict_translate("Monitor"); ></th></tr>
	<tr>
	<td colspan="2" id="extrainfo">
	<span
	id="throughputgraph" class="all"><a href="throughput.cgi" target="extraFrame"><? echo dict_translate("Throughput"); ></a> | </span><span
	id="stalist" class="apinfo"><a href="stalist.cgi" target="extraFrame"><? echo dict_translate("Stations"); ></a> | </span><span
	id="stainfo" class="stainfo"><a href="stainfo.cgi" id="a_stainfo" name="a_stainfo" target="extraFrame"><? echo dict_translate("AP Information"); ></a> | </span><span
	id="ppp_info" class="router"><a href="pppinfo.cgi" target="extraFrame"><? echo dict_translate("PPPoE Information"); ></a> | </span><span
	id="dhcpc_info"><a href="dhcpc.cgi" target="extraFrame"><? echo dict_translate("DHCP Client"); ></a> | </span><span
	id="arp" class="all"><a href="arp.cgi" target="extraFrame"><? echo dict_translate("ARP Table"); ></a> | </span><span
	id="brmacs" class="bridge"><a href="brmacs.cgi" target="extraFrame"><? echo dict_translate("Bridge Table"); ></a> | </span><span
	id="sroutes" class="all"><a href="sroutes.cgi" target="extraFrame"><? echo dict_translate("Routes"); ></a> | </span><span
	id="fwall"><a href="fw.cgi?netmode=<? echo $netmode;>" id="a_fw" target="extraFrame"><? echo dict_translate("Firewall"); ></a> | </span><span
	id="pfw" class="router"><a href="pfw.cgi" target="extraFrame"><? echo dict_translate("Port Forward"); ></a> | </span><span
	id="dhcp_leases" class="router"><a href="leases.cgi" target="extraFrame"><? echo dict_translate("DHCP Leases"); ></a> | </span><span
	id="log" class="all"><a href="log.cgi" target="extraFrame"><? echo dict_translate("Log"); ></a></span>
	</td>
	</tr>
	<tr>
	<td colspan="2" align="center">
<div id="extraFrame">
</div>
	</td>
	</tr>
	</table>
	</td>
	</tr>
	<tr> <td height="10" colspan="2" class="foot"><? echo dict_translate($oem_copyright); > </td></tr>
</table>
</body>
</html>
