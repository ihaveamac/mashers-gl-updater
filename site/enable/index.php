<?php
if (isset($_GET["enable"])) {
	file_put_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate-2/enabled", $_GET["enable"]);
}

$state = true;
if (file_get_contents($_SERVER["DOCUMENT_ROOT"]."/mglupdate-2/enabled") !== "yes") $state = false;
?>
<h2>The updater is: <?php echo ($state) ? "ON" : "OFF"; ?></h2>
<p>Did you break something again?</p>
<p><a href="https://ianburgwin.net/mglupdate-2/enable/?enable=<?php echo ($state) ? 'no' : 'yes'; ?>"><?php echo ($state) ? 'Disable' : 'Enable'; ?> updater</a></p>
