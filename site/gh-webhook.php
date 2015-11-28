<?php
header("Content-Type: none");

// get secret
$secret = "";
require("gh-webhook-config.php");
$json = file_get_contents('php://input');
$headers = getallheaders();

// verify requester
if (!isset($headers['X-Hub-Signature'])) {
    echo "You need to prove to me that you're GitHub!"; die;
} elseif ("sha1=".hash_hmac("sha1", $json, $secret) !== $headers['X-Hub-Signature']) {
    echo "You're not GitHub!"; die;
}

// turn into array
$push = json_decode($json, true);

// return result for GitHub
$result = "checks:\n";
$result .= " - can I see X-GitHub-Event?  ".(isset($headers['X-Github-Event']) ? "yes: \"".$headers['X-Github-Event']."\"" : "no...")."\n";
$result .= " - can I see X-Hub-Signature? ".(isset($headers['X-Hub-Signature']) ? "yes: \"".$headers['X-Hub-Signature']."\"" : "no...")."\n";
$result .= " - does it pass the test?     ".("sha1=".hash_hmac("sha1", $json, $secret) == $headers['X-Hub-Signature'] ? "yes!" : "no...")."\n";
$result .= "\n-----\n".print_r($headers, true)."-----\n".print_r(json_decode($json, true), true);
echo $result;

// temporary local logging
file_put_contents(__DIR__."/gh-webhook-logtest/webhooktest_".time().".txt", $result);