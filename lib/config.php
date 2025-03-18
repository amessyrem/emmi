<?php
$host = "localhost";
$db_name = "UserInfosDB";
$username = "root";
$password = ""; // Varsayılan XAMPP MySQL şifresi boş

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Bağlantı başarılı!";
} catch (PDOException $exception) {
    die("Veritabanı bağlantı hatası: " . $exception->getMessage());
}
?>