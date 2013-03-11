<?php

$airport = isset($_REQUEST['airport']) ? urlencode($_REQUEST['airport'] . " airport") : urlencode("AUS airport");

$data = file_get_contents("http://maps.googleapis.com/maps/api/geocode/json?address={$airport}&sensor=true");

$data = json_decode($data, true);
$data = $data['results']['0'];
$ll = $data['geometry']['location'];

$data = file_get_contents("http://i.wxbug.net/REST/Direct/GetObs.ashx?la={$ll['lat']}&lo={$ll['lng']}&api_key=bgmwrx6ng282uzz9dyzgfgde");
$data = json_decode($data);

header("Content-Type: application/json");
echo json_encode(array('temperature' => $data->temperature));