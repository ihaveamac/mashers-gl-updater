<?php
$result = "test";
if (file_get_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/state.txt") == "DOWNLOADING") {
	$result = "DOWNLOADING";
} else {
	$versionh_local = file_get_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version.h");
	$versionh_server = file_get_contents("https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/source/version.h");
	if (strcmp($versionh_server, $versionh_local) !== 0) {
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/state.txt", "DOWNLOADING");
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version.h", ""); // blank = server is busy to client
	
		$boot3dsx = file_get_contents("https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/boot1.3dsx");
		
		unlink($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version.h");
		unlink($_SERVER["DOCUMENT_ROOT"]."/mglupdate/boot1.3dsx");
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/version.h", $versionh_server);
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/boot1.3dsx", $boot3dsx);
		file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate/state.txt", "READY");
		$result = "READY:".$versionh_server;
	} else {
		$result = "READY:".$versionh_local;
	}
}
echo $result;
