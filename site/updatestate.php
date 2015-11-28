<?php
if (file_get_contents(__DIR__."/enabled") !== "yes") header("HTTP/1.0 404 Not Found"); // breaks the updater program
$result = ".";
$versionh_local = file_get_contents(__DIR__."/version.h");
if ($versionh_local == "notready") {
	$result = "DOWNLOADING";
} else {
	$versionh_server = trim(file_get_contents("https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/source/version.h"));
	if ($versionh_server == "Not Found") {
		$result = "READY";
		file_put_contents(__DIR__."/enabled", "no");
	} elseif (strcmp($versionh_server, $versionh_local) !== 0) {
		file_put_contents(__DIR__."/version.h", "notready"); // notready = server is busy to client
		
		$boot3dsx = file_get_contents("https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/launcher.zip");
		
		unlink(__DIR__."/version.h");
		unlink(__DIR__."/launcher.zip");
		file_put_contents(__DIR__."/version.h", $versionh_server);
		file_put_contents(__DIR__."/launcher.zip", $boot3dsx);
		$result = "READY";
	} else {
		$result = "READY";
	}
}
echo $result;
