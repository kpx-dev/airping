<?php

$_GET['to'] = urlencode($_GET['to']. " airport");

$tdata = file_get_contents("http://maps.googleapis.com/maps/api/directions/json?origin={$_GET['from']}&destination={$_GET['to']}&sensor=false");
$tdata = json_decode($tdata, true);
print_r(json_encode($tdata['routes'][0]['legs'][0]['duration']));
