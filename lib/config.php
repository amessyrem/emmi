<?php
$host = "localhost";
$db_name = "UserInfosDB";
$username = "root";
$password = "";

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $exception) {
    die(json_encode(["success" => false, "message" => "Veritabanı bağlantı hatası"]));
}
?>
