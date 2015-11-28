<?php
header("Content-Type: none");

// get secret and set config
$secret = "";
$force_download = false;
include_once("gh-webhook-config.php");
$json = file_get_contents('php://input');
$headers = getallheaders();

// verify requester
if (!isset($headers['X-Hub-Signature'])) {
    echo "You need to prove to me that you're GitHub!"; die;
} elseif ("sha1=".hash_hmac("sha1", $json, $secret) !== $headers['X-Hub-Signature']) {
    echo "You're not GitHub!"; die;
}

$result = "verified! :D\n";

// turn into array
$push = json_decode($json, true);

// check for version or changelog change, and update if necessary
$downloaded = false;
foreach ($push["commits"] as $commit) {
    foreach ($commit["modified"] as $filename) {
        if ($filename == "source/version.h" or $force_download) {
            unlink("launcher.zip");
            file_put_contents("version.h", "notready"); // "notready" = 3DS will wait for server to cache
            $versionh = trim(file_get_contents("https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/source/version.h"));
            file_put_contents("version.h", $versionh);
            $launcherzip = file_get_contents("https://raw.githubusercontent.com/mashers/3ds_hb_menu/master/launcher.zip");
            file_put_contents("launcher.zip", $launcherzip);
            $result .= " > saved version.h and launcher.zip\n";
            $downloaded = true;
        }
        if ($filename == "Updating/Updating-Changelog.md" or $force_download) {
            unlink("Updating-Changelog.md");
            $changelog_release = file_get_contents("https://raw.githubusercontent.com/RedInquisitive/3DS-Homebrew-Menu-Wiki/master/Updating/Updating-Changelog.md");
            file_put_contents("Updating-Changelog.md", $changelog_release);
            $result .= " > saved Updating-Changelog.md\n";
            $downloaded = true;
        }
        if ($filename == "Updating/Updating-Changelog-Beta.md" or $force_download) {
            unlink("Updating-Changelog-Beta.md");
            $changelog_beta = file_get_contents("https://raw.githubusercontent.com/RedInquisitive/3DS-Homebrew-Menu-Wiki/master/Updating/Updating-Changelog-Beta.md");
            file_put_contents("Updating-Changelog-Beta.md", $changelog_beta);
            $result .= " > saved Updating-Changelog-Beta.md\n";
            $downloaded = true;
        }
        if ($downloaded) {
            break;
        }
    }
}

// return result for GitHub
$result .= " - list changed files:\n";
foreach ($push["commits"] as $commit) {
    foreach ($commit["modified"] as $filename) {
        $result .= "   - ".$filename."\n";
    }
}
$result .= "-----\n".print_r($headers, true)."-----\n".print_r($push, true);
echo $result;

// temporary local logging
file_put_contents("gh-webhook-logtest/webhooktest_".time().".txt", $result);
