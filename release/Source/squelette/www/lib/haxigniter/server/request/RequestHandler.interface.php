<?php

interface haxigniter_server_request_RequestHandler {
	function handleRequest($controller, $url, $method, $getPostData, $requestData);
}
