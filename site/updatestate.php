<?php
$result = ".";
$versionh_local = file_get_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version.h2");
if ($versionh_local == "notready") {
	$result = "DOWNLOADING";
} else {
	$versionh_server = trim(file_get_contents("https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/source/version.h"));
	if (strcmp($versionh_server, $versionh_local) !== 0) {
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version_info", "notready"); // notready = server is busy to client
		
		$boot3dsx = file_get_contents("https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/boot1.3dsx");
		
		unlink($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version.h2");
		unlink($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version_info");
		unlink($_SERVER["DOCUMENT_ROOT"]."/mglupdate/boot1.3dsx");
		$version_info = substr($versionh_server, 23)."|".file_get_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/mglu_version");
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version.h2", $versionh_server);
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/boot1.3dsx", $boot3dsx);
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version_info", $version_info);
		$result = "READY";
	} else {
		$result = "READY";
	}
}
echo $result;
