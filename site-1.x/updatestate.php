<?php
$result = ".";
$versionh_local = file_get_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version.h");
if ($versionh_local == "notready") {
	$result = "DOWNLOADING";
} else {
	$versionh_server = trim(file_get_contents("https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/source/version.h"));
	if (strcmp($versionh_server, $versionh_local) !== 0) {
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version.h", "notready"); // notready = server is busy to client
		
		$boot3dsx = file_get_contents("https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/boot1.3dsx");
		
		unlink($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version.h");
		unlink($_SERVER["DOCUMENT_ROOT"]."/mglupdate/boot1.3dsx");
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version.h", $versionh_server);
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/boot1.3dsx", $boot3dsx);
		$result = "READY";
	} else {
		$result = "READY";
	}
}
echo $result;
