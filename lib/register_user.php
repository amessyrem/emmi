<?php
// Veritabanı bağlantısı
$servername = "localhost";  // DB sunucu adı
$username = "root";         // DB kullanıcı adı
$password = "";             // DB şifresi
$dbname = "UserInfosDB";    // Veritabanı adı

$conn = new mysqli($servername, $username, $password, $dbname);

// Bağlantıyı kontrol et
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Veriyi al
$data = json_decode(file_get_contents("php://input"), true);
$isim = $data["isim"];
$soyisim = $data["soyisim"];
$kullaniciAdi = $data["kullanici_adi"];
$sifre = password_hash($data["sifre"], PASSWORD_DEFAULT);  // Şifreyi güvenli bir şekilde hash'le
$telefon = $data["telefon"];

// Kullanıcıyı veritabanına ekle
$sql = "INSERT INTO users (isim, soyisim, kullanici_adi, sifre, telefon)
        VALUES ('$isim', '$soyisim', '$kullaniciAdi', '$sifre', '$telefon')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["success" => true, "message" => "Kayıt başarılı"]);
} else {
    echo json_encode(["success" => false, "message" => "Kayıt sırasında bir hata oluştu: " . $conn->error]);
}

$conn->close();
?>