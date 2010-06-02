#!/sbin/cgi
<?
include("lib/settings.inc");
$cfg = @cfg_load($cfg_file);
include("lib/l10n.inc");
include("lib/link.inc");
include("lib/misc.inc");

$autoack = cfg_get_def($cfg, "radio.1.ack.auto", "disabled");
$wmode = cfg_get_wmode($cfg, $wlan_iface);
$polling = cfg_get_def($cfg, "radio.1.polling", "disabled");

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

$sta_info_refresh = 0;
Exec($cmd_wstalist + " " + $ifname + " " + $sta_mac, $arr, $result);
if ($result == 0 && count($arr) > 1)
{
	$sta_info_refresh = 1;
	$i = 1;
	$info = split("|", $arr[$i]);
	$i++;
	/* "  Rates: " */
	$rates = split(" ", substr($arr[$i], 9, strlen($arr[$i]) - 9));
	$rate_count = count($rates);
	$i++;
	/* "  Signals: " */
	$signals = split(" ", substr($arr[$i], 11, strlen($arr[$i]) - 11));
	$i++;
	/* "  Stats: " */
	$stats = split("|", substr($arr[$i], 9, strlen($arr[$i]) - 9));
	$i++;
}

$wds_node = 0;
if ($mode == "ap")
{
	$page_title = dict_translate("AP Info:") + $sta_mac;
	$heading = dict_translate("Access Point") + " &nbsp; &nbsp; &nbsp; &nbsp; " + $info[0];
	$no_sta_msg = dict_translate("Not associated, no information available.");
}
else
{
	$page_title = dict_translate("Station Info: ")+$sta_mac;
	$heading = dict_translate("Station") + " &nbsp; &nbsp; &nbsp; &nbsp; " + $info[0];
	if ($info[8] == "Yes") {
		$wds_node = 1;
		$heading += " (" + dict_translate("AP-WDS") +")";
	}
	$heading += " &nbsp; &nbsp; [ " + $info[1] + " ]";
	$no_sta_msg = dict_translate("No such station associated.");
}
include("lib/stainfo.tmpl");
>
