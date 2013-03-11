<?php // -*- c-basic-offset: 2 -*-
header("Content-Type: application/json");

class Api extends Pest
{
  public function post($url, $data = array(), $headers=array()) {
    return parent::post($url, json_encode($data), $headers);
  }

  public function put($url, $data, $headers=array()) {
    return parent::put($url, json_encode($data), $headers);
  }

  protected function prepRequest($opts, $url) {
    $opts[CURLOPT_HTTPHEADER][] = 'Accept: application/json';
    $opts[CURLOPT_HTTPHEADER][] = 'Content-Type: application/json';
    return parent::prepRequest($opts, $url);
  }

  public function processBody($body) {
    return json_decode($body, true);
  }
}


/**
 * Pest is a REST client for PHP.
 *
 * See http://github.com/educoder/pest for details.
 *
 * This code is licensed for use, modification, and distribution
 * under the terms of the MIT License (see http://en.wikipedia.org/wiki/MIT_License)
 */
class Pest {
  public $curl_opts = array(
  	CURLOPT_RETURNTRANSFER => true,  // return result instead of echoing
  	CURLOPT_SSL_VERIFYPEER => false, // stop cURL from verifying the peer's certificate
  	CURLOPT_FOLLOWLOCATION => false,  // follow redirects, Location: headers
  	CURLOPT_MAXREDIRS      => 10     // but dont redirect more than 10 times
  );

  public $base_url;

  public $last_response;
  public $last_request;
  public $last_headers;

  public $throw_exceptions = true;

  public function __construct($base_url) {
    if (!function_exists('curl_init')) {
  	    throw new Exception('CURL module not available! Pest requires CURL. See http://php.net/manual/en/book.curl.php');
  	}

  	// only enable CURLOPT_FOLLOWLOCATION if safe_mode and open_base_dir are not in use
  	if(ini_get('open_basedir') == '' && strtolower(ini_get('safe_mode')) == 'off') {
  	  $this->curl_opts['CURLOPT_FOLLOWLOCATION'] = true;
  	}

    $this->base_url = $base_url;

    // The callback to handle return headers
    // Using PHP 5.2, it cannot be initialised in the static context
    $this->curl_opts[CURLOPT_HEADERFUNCTION] = array($this, 'handle_header');
  }

  // $auth can be 'basic' or 'digest'
  public function setupAuth($user, $pass, $auth = 'basic') {
    $this->curl_opts[CURLOPT_HTTPAUTH] = constant('CURLAUTH_'.strtoupper($auth));
    $this->curl_opts[CURLOPT_USERPWD] = $user . ":" . $pass;
  }

  // Enable a proxy
  public function setupProxy($host, $port, $user = NULL, $pass = NULL) {
    $this->curl_opts[CURLOPT_PROXYTYPE] = 'HTTP';
    $this->curl_opts[CURLOPT_PROXY] = $host;
    $this->curl_opts[CURLOPT_PROXYPORT] = $port;
    if ($user && $pass) {
      $this->curl_opts[CURLOPT_PROXYUSERPWD] = $user . ":" . $pass;
    }
  }

  public function get($url) {
    $curl = $this->prepRequest($this->curl_opts, $url);
    $body = $this->doRequest($curl);

    $body = $this->processBody($body);

    return $body;
  }

  public function head($url) {
    $curl_opts = $this->curl_opts;
    $curl_opts[CURLOPT_NOBODY] = true;

    $curl = $this->prepRequest($this->curl_opts, $url);
    $body = $this->doRequest($curl);

    $body = $this->processBody($body);

    return $body;
  }

  public function prepData($data) {
    if (is_array($data)) {
        $multipart = false;

        foreach ($data as $item) {
            if (is_string($item) && strncmp($item, "@", 1) == 0 && is_file(substr($item, 1))) {
                $multipart = true;
                break;
            }
        }

        return ($multipart) ? $data : http_build_query($data);
    } else {
        return $data;
    }
  }

  public function post($url, $data = array(), $headers=array()) {
    $data = $this->prepData($data);

    $curl_opts = $this->curl_opts;
    $curl_opts[CURLOPT_CUSTOMREQUEST] = 'POST';
    if (!is_array($data)) $headers[] = 'Content-Length: '.strlen($data);
    $curl_opts[CURLOPT_HTTPHEADER] = $headers;
    $curl_opts[CURLOPT_POSTFIELDS] = $data;

    $curl = $this->prepRequest($curl_opts, $url);
    $body = $this->doRequest($curl);

    $body = $this->processBody($body);

    return $body;
  }

  public function put($url, $data, $headers=array()) {
    $data = $this->prepData($data);

    $curl_opts = $this->curl_opts;
    $curl_opts[CURLOPT_CUSTOMREQUEST] = 'PUT';
    if (!is_array($data)) $headers[] = 'Content-Length: '.strlen($data);
    $curl_opts[CURLOPT_HTTPHEADER] = $headers;
    $curl_opts[CURLOPT_POSTFIELDS] = $data;

    $curl = $this->prepRequest($curl_opts, $url);
    $body = $this->doRequest($curl);

    $body = $this->processBody($body);

    return $body;
  }

    public function patch($url, $data, $headers=array()) {
    $data = (is_array($data)) ? http_build_query($data) : $data;

    $curl_opts = $this->curl_opts;
    $curl_opts[CURLOPT_CUSTOMREQUEST] = 'PATCH';
    $headers[] = 'Content-Length: '.strlen($data);
    $curl_opts[CURLOPT_HTTPHEADER] = $headers;
    $curl_opts[CURLOPT_POSTFIELDS] = $data;

    $curl = $this->prepRequest($curl_opts, $url);
    $body = $this->doRequest($curl);

    $body = $this->processBody($body);

    return $body;
  }

  public function delete($url) {
    $curl_opts = $this->curl_opts;
    $curl_opts[CURLOPT_CUSTOMREQUEST] = 'DELETE';

    $curl = $this->prepRequest($curl_opts, $url);
    $body = $this->doRequest($curl);

    $body = $this->processBody($body);

    return $body;
  }

  public function lastBody() {
    return $this->last_response['body'];
  }

  public function lastStatus() {
    return $this->last_response['meta']['http_code'];
  }

  /**
   * Return the last response header (case insensitive) or NULL if not present.
   * HTTP allows empty headers (e.g. RFC 2616, Section 14.23), thus is_null()
   * and not negation or empty() should be used.
   */
  public function lastHeader($header) {
    if (empty($this->last_headers[strtolower($header)])) {
      return NULL;
    }
    return $this->last_headers[strtolower($header)];
  }

  protected function processBody($body) {
    // Override this in classes that extend Pest.
    // The body of every GET/POST/PUT/DELETE response goes through
    // here prior to being returned.
    return $body;
  }

  protected function processError($body) {
    // Override this in classes that extend Pest.
    // The body of every erroneous (non-2xx/3xx) GET/POST/PUT/DELETE
    // response goes through here prior to being used as the 'message'
    // of the resulting Pest_Exception
    return $body;
  }


  protected function prepRequest($opts, $url) {
    if (strncmp($url, $this->base_url, strlen($this->base_url)) != 0) {
      $url = rtrim($this->base_url, '/') . '/' . ltrim($url, '/');
    }
    $curl = curl_init($url);

    foreach ($opts as $opt => $val)
      curl_setopt($curl, $opt, $val);

    $this->last_request = array(
      'url' => $url
    );

    if (isset($opts[CURLOPT_CUSTOMREQUEST]))
      $this->last_request['method'] = $opts[CURLOPT_CUSTOMREQUEST];
    else
      $this->last_request['method'] = 'GET';

    if (isset($opts[CURLOPT_POSTFIELDS]))
      $this->last_request['data'] = $opts[CURLOPT_POSTFIELDS];

    return $curl;
  }

  private function handle_header($ch, $str) {
    if (preg_match('/([^:]+):\s(.+)/m', $str, $match) ) {
      $this->last_headers[strtolower($match[1])] = trim($match[2]);
    }
    return strlen($str);
  }

  private function doRequest($curl) {
    $this->last_headers = array();

    $body = curl_exec($curl);
    $meta = curl_getinfo($curl);

    $this->last_response = array(
      'body' => $body,
      'meta' => $meta
    );

    curl_close($curl);

    $this->checkLastResponseForError();

    return $body;
  }

  protected function checkLastResponseForError() {
    if ( !$this->throw_exceptions)
      return;

    $meta = $this->last_response['meta'];
    $body = $this->last_response['body'];

    if (!$meta)
      return;

    $err = null;
    switch ($meta['http_code']) {
      case 400:
        throw new Pest_BadRequest($this->processError($body));
        break;
      case 401:
        throw new Pest_Unauthorized($this->processError($body));
        break;
      case 403:
        throw new Pest_Forbidden($this->processError($body));
        break;
      case 404:
        throw new Pest_NotFound($this->processError($body));
        break;
      case 405:
        throw new Pest_MethodNotAllowed($this->processError($body));
        break;
      case 409:
        throw new Pest_Conflict($this->processError($body));
        break;
      case 410:
        throw new Pest_Gone($this->processError($body));
        break;
      case 422:
        // Unprocessable Entity -- see http://www.iana.org/assignments/http-status-codes
        // This is now commonly used (in Rails, at least) to indicate
        // a response to a request that is syntactically correct,
        // but semantically invalid (for example, when trying to
        // create a resource with some required fields missing)
        throw new Pest_InvalidRecord($this->processError($body));
        break;
      default:
        if ($meta['http_code'] >= 400 && $meta['http_code'] <= 499)
          throw new Pest_ClientError($this->processError($body));
        elseif ($meta['http_code'] >= 500 && $meta['http_code'] <= 599)
          throw new Pest_ServerError($this->processError($body));
        elseif (!$meta['http_code'] || $meta['http_code'] >= 600) {
          throw new Pest_UnknownResponse($this->processError($body));
        }
    }
  }
}


class Pest_Exception extends Exception { }
class Pest_UnknownResponse extends Pest_Exception { }

/* 401-499 */ class Pest_ClientError extends Pest_Exception {}
/* 400 */ class Pest_BadRequest extends Pest_ClientError {}
/* 401 */ class Pest_Unauthorized extends Pest_ClientError {}
/* 403 */ class Pest_Forbidden extends Pest_ClientError {}
/* 404 */ class Pest_NotFound extends Pest_ClientError {}
/* 405 */ class Pest_MethodNotAllowed extends Pest_ClientError {}
/* 409 */ class Pest_Conflict extends Pest_ClientError {}
/* 410 */ class Pest_Gone extends Pest_ClientError {}
/* 422 */ class Pest_InvalidRecord extends Pest_ClientError {}

/* 500-599 */ class Pest_ServerError extends Pest_Exception {}


$base_url = 'https://aahackathon.api.layer7.com:9443/AA1/';
$api_key = 'l7xxb02952c6db1e4d82a012b0b7f8fcd63d';
$aa_advantage = isset($_REQUEST['aa_advantage']) ? $_REQUEST['aa_advantage'] : '598FXT4';

$flight_status = 'ON TIME';
switch($aa_advantage)
{
  case '6AK1542':
  case '596N5B8':
    $flight_status = 'DELAYED';
  break;
}

echo '{"boarding":"2013-03-10T19:00:00.000-05:00","changed":null,"flight_status":"' . $flight_status . '","flight_number":"427","origin_code":"AUS","destination_code":"LAX","terminal":null,"gate":"13","aa_advantage":"' . $aa_advantage . '"}';
exit;


#$url = $base_url . 'login?aadvantageNumber=6AK1542&password=testing&apikey=l7xxb02952c6db1e4d82a012b0b7f8fcd63d';

$api = new Api($base_url);

// Login
$call = 'login?aadvantageNumber=' . $aa_advantage . '&password=testing&apikey=' . $api_key;
$customer = $api->post($call);
$account = $customer['login']['accountInfo'];
#var_dump($account);exit;
#$user1 = "{"login":{"loginSuccessful":true,"accountInfo":{"firstName":"CHRIS","tierLevel":{"code":"P","description":"PLATINUM"},"AAdvantageNumber":"6AK1542","lastName":"ARMSTRONG","middleName":""},"infoMessages":"","fieldErrors":"","messageParams":null,"presentationErrors":""}}";

// Reservation List
$call = "reservationlist?&aadvantageNumber=" . $account['AAdvantageNumber'] . "&password=testing&apikey=$api_key";
#$call .= '&noWindowCheck=false';

$reservation = $api->get($call);
$flights = $reservation['myFlights']['reservationList']['0'];

$record_locator = $flights['recordLocator'];
$flight_date = $flights['flightDate'];
#reservationName

$my_reservation = $flights['reservation'];

$payload = array(
	'boarding' => $my_reservation['flights']['0']['0']['boardingTime'],
	'changed' => $my_reservation['flights']['0']['0']['scheduleChange'],
	'flight_status' => $my_reservation['flights']['0']['0']['flightStatus']['originInfo']['flightStatus'],
	'flight_number' => $my_reservation['flights']['0']['0']['flightNumber'],
	'origin_code' => $my_reservation['flights']['0']['0']['originAirportCode'],
	'destination_code' => $my_reservation['flights']['0']['0']['destinationAirportCode'],
	'terminal' => $my_reservation['flights']['0']['0']['flightStatus']['originInfo']['terminal'],
	'gate' => $my_reservation['flights']['0']['0']['flightStatus']['originInfo']['gate'],
	'aa_advantage' => $aa_advantage
);


echo json_encode($payload);
