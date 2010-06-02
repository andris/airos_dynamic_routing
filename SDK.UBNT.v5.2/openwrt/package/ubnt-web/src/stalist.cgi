#!/sbin/cgi
<?
include("lib/settings.inc");
$cfg = @cfg_load($cfg_file);
include("lib/l10n.inc");
include("lib/misc.inc");

$autoack = cfg_get_def($cfg, "radio.1.ack.auto", "disabled");
$global_ack = 0;
if ($autoack == "enabled") {
	$global_ack = get_current_ack();
}

Function split $delimiter, $string (
	$reminder = $string;
	$delimiterlen = strlen($delimiter);

	if ($delimiterlen > 0)
	{
		$chunk = strstr($reminder, $delimiter);
		$chunklen = strlen($chunk);
	}
	else
	{
		$chunklen = 0;
	}
	while ($chunklen != 0)
	{
		$reminderlen = strlen($reminder);
		$part = substr($reminder, 0, $reminderlen - $chunklen);
		$result[] = substr($reminder, 0, $reminderlen - $chunklen);
		$reminder = substr($chunk, $delimiterlen, $chunklen - $delimiterlen);
		$chunk = strstr($reminder, $delimiter);
		$chunklen = strlen($chunk);
	}
	$result[] = $reminder;
	return $result;
);

$page_title=dict_translate("Associated Stations");
include("lib/stable_head.tmpl");
>
<tr>
<th><? echo dict_translate("Station MAC"); >&nbsp;&nbsp;&nbsp;</th>
<th><? echo dict_translate("Device Name"); >&nbsp;&nbsp;&nbsp;</th>
<th><? echo dict_translate("Signal") + " / "+ dict_translate("Noise"); >, dBm&nbsp;&nbsp;&nbsp;</th>
<? if ($autoack == "enabled") { >
	<th><? echo dict_translate("ACK"); >&nbsp;&nbsp;&nbsp;</th>
<? } >
<th><? echo dict_translate("TX/RX"); >, Mbps&nbsp;&nbsp;&nbsp;</th>
<th><? echo dict_translate("CCQ"); >, %&nbsp;&nbsp;&nbsp;</th>
<th><? echo dict_translate("Connection Time"); >&nbsp;&nbsp;&nbsp;</th>
<th><? echo dict_translate("Last IP"); >&nbsp;&nbsp;&nbsp;</th>
<th><? echo dict_translate("Action"); >&nbsp;</th>
</tr>
<?
flush();

Exec($cmd_wstalist + " " + $wlan_iface, $arr, $result);

if ($result == 0)
{
	$size = count($arr);
	$i = 1;
	$n = 0;
	while($i < $size)
	{
		$info = split("|", $arr[$i]);
		if (intVal($info[2]) == 0)
		{
			$info[2] = "-";
		}
		if (intVal($info[3]) == 0)
		{
			$info[3] = "-";
		}

		$info[5] = IntVal($info[5]) / 10;
		if ($autoack == "enabled" && intVal($info[11]) == 0)
		{
			$info[11] = $global_ack;
		}

		$win_height = 400;
		$rates = split(" ", substr($arr[$i+1], 9, strlen($arr[$i+1]) - 9));
		$rate_count = count($rates);
		if ($rate_count > 8) {
			$win_height += 120;
		}
>
	<tr>
	<td><a href="#" onClick="openPage('stainfo.cgi?ifname=<? echo $wlan_iface;>&sta_mac=<? echo $info[0];>', 700,<? echo $win_height;>);">
<?
		echo $info[0]+"</a>";
		if ($info[8] == "Yes")
		{
			echo " (" + dict_translate("AP-WDS") + ")";
		}
		echo "&nbsp;&nbsp;&nbsp;</td>";
		echo "<td>" + $info[12] + "&nbsp;</td>";
		echo "<td class=\"centered\">" + intVal($info[4]) + "&nbsp;/&nbsp;" + $info[9] + "</td>";
		if ($autoack == "enabled") {
			echo "<td class=\"centered\">" + $info[11] + "</td>";
		}
		echo "<td class=\"centered\">" + $info[2] + "&nbsp;/&nbsp;" + $info[3] + "</td>";
		echo "<td class=\"centered\">" + $info[5] + "</td>";
		echo "<td>" + secsToCountdown($info[7]) + "</td>";
		$lastip = $info[13];
		if ($lastip == "0.0.0.0") {
			$lastip_str = dict_translate("unknown");
		} else {
			$lastip_str = "<a href=\"http://" + $lastip + "\" target=\"_blank\">" + $lastip + "</a>"; 
		}
		echo "<td>" + $lastip_str + "</td>";
		echo "<td>&nbsp;";
		/* no kicking for AP-WDS entries */
		if ($info[8] != "Yes") {
			echo "<a href=\"#\" onClick=\"return kickStation(this,'$wlan_iface','" + $info[0] + "');\">" + dict_translate("kick") + "</a>";
		}
		echo "</td>";
		echo "</tr>\n";
		/* "  Rates: " */
		/* "  Signals: " */
		/* "  Stats: " */
		$i += 4;
		$n++;
	}
} else {>
<tr><td colspan="6"><? echo dict_translate("No Associated Stations"); ></td></tr>
<?}
include("lib/arp_tail.tmpl");
>
