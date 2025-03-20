<?php
include "config.php"; // Bağlantı dosyanı dahil et

// Veriyi JSON olarak al
$data = json_decode(file_get_contents("php://input"), true);

if (!$data || !isset($data["isim"], $data["soyisim"], $data["kullanici_adi"], $data["sifre"], $data["telefon"])) {
    echo json_encode(["success" => false, "message" => "Eksik veri gönderildi!"]);
    exit;
}

$isim = htmlspecialchars($data["isim"]); // XSS saldırılarını önlemek için
$soyisim = htmlspecialchars($data["soyisim"]);
$kullaniciAdi = htmlspecialchars($data["kullanici_adi"]);
$sifre = password_hash($data["sifre"], PASSWORD_DEFAULT);
$telefon = htmlspecialchars($data["telefon"]);

try {
    // Hazır (Prepared) SQL Sorgusu kullanarak SQL Injection saldırılarını önle
    $stmt = $conn->prepare("INSERT INTO users (isim, soyisim, kullanici_adi, sifre, telefon) VALUES (:isim, :soyisim, :kullaniciAdi, :sifre, :telefon)");
    $stmt->bindParam(':isim', $isim);
    $stmt->bindParam(':soyisim', $soyisim);
    $stmt->bindParam(':kullaniciAdi', $kullaniciAdi);
    $stmt->bindParam(':sifre', $sifre);
    $stmt->bindParam(':telefon', $telefon);

    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Kayıt başarılı"]);
    } else {
        echo json_encode(["success" => false, "message" => "Kayıt sırasında bir hata oluştu"]);
    }
} catch (PDOException $e) {
    echo json_encode(["success" => false, "message" => "Veritabanı hatası: " . $e->getMessage()]);
}
?>
