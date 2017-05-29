import processing.sound.*;
SoundFile music; // Arkaplan müziği için

private PImage arkaplan; // Arkaplan resmini tutacak
private PFont yaziTipi; // Yazı tipini tutacak

private Gemi oyuncu; // Oyuncu nesnesini tutacak

private ArrayList<Engel> ada = new ArrayList<Engel>(); // Engel nesnelerini tutacak

private int arkaplanY = 0; // Birincil arkaplanın Y konumu

private int oyuncuYatayHizi = 4;
private int oyuncuDikeyHizi = 2;
private int oyuncuDususHizi = 1; /* Oyuncunun hareket hızlarını belirle */

private boolean oyuncuSagaGit = false, oyuncuSolaGit = false; // Oyuncu için X düzleminde hareket kontrolü
private boolean oyuncuYukariGit = false; // Oyuncu için X düzleminde hareket kontrolü

private int engelHiziMin = oyuncuDususHizi * 2; // Engellerin minimum kayış hızını belirle
private int engelHiziMax = oyuncuDikeyHizi * 2; // Engellerin maksimum kayış hızını belirle
private int engelHizi = engelHiziMin; // Engelin geçerli kayış hızını ayarla

private int[] engelHiza = new int[2]; // Son oluşturulan 2 engelin hizasını tutacak
private byte hizaIndex = 0; // Son eklenen engelin engelHiza içinde hangi indekse koyulacağını tutacak

private int puan = 0; // Oyuncunun skorunu tutacak
private int gecilenEngel = 0; // Seviye atlamak için

private boolean seviyeAtla = false; // Daha Hızlı! bilgilendirmesi ekrandayken true olur
private int seviyeGecisZamani = 0; // 1 sn sonra seviyeAtla'yı false yapar

private boolean oyunBitti = false; // Oyun bittiğinde true olur

final void setup() {
  size(450, 700); // Pencere boyutunu ayarla
 
  arkaplan = loadImage("deniz.png"); // Arkaplan resmini ayarla
  
  /* Yazı Fontunu Ayarla Ve Yatay Olarak Yazıyı Ortala */
  yaziTipi = loadFont("GochiHand-Regular-72.vlw");
  textFont(yaziTipi);
  
  /* 180 = width / 3, 634 = height - grafik.height - 30, 534 = 634 - 100 */
  oyuncu = new Gemi(180, 470, 400, 470); // Oyuncu objesini oluştur
  
  EngelOlustur();
  
  music = new SoundFile(this, "music.mp3"); // Arkaplan müziğini yükle
  music.loop(); // Müzik sürekli tekrarlasın
}


final void keyPressed() {
  switch(key) { // Basılan tuş
    case 'a' :
    case 'A' : // A ise
      oyuncuSolaGit = true; // Gemi sola hareket aldı
    break;
    
    case 'd' :
    case 'D' : // D ise
      oyuncuSagaGit = true; // Gemi sağa hareket aldı
    break;
    
    case 'w' :
    case 'W' : // W ise
      oyuncuYukariGit = true; // Gemiye gaz verildi
    break;
    
    case 'r' :
    case 'R' : // R ise
      if (oyunBitti) { // Oyun bitmiş ve henüz yeniden başlatma onayı verilmemişse
        OyunuYenidenBaslat(); // Oyunu yeniden başlat
      }
    break;
  }
}


final void keyReleased() {
  switch(key) { // Bırakılan tuş
    case 'a' :
    case 'A' : // A ise
      oyuncuSolaGit = false; // Gemi artık sola gitmiyor
    break;
    
    case 'd' :
    case 'D' : // D ise
      oyuncuSagaGit = false; // Gemi artık sağa gitmiyor
    break;
    
    case 'w' :
    case 'W' : // W ise
      oyuncuYukariGit = false; // Gemi gaz kesti
    break;
  }
}


/* Oyuncuyu Ekranda Hareket Ettir */
private final void GemiManevra() {
  if (oyuncuSagaGit) 
    oyuncu.YanaGit(oyuncuYatayHizi); // Gereken tuşa basılıyorsa oyuncuyu sağa hareket ettir
    
  if (oyuncuSolaGit)
     oyuncu.YanaGit(-oyuncuYatayHizi); // Gereken tuşa basılıyorsa oyuncuyu sola hareket ettir
  
  if (oyuncuYukariGit) {
    oyuncu.IleriGit(-oyuncuDikeyHizi); // Gereken tuşa basılıyorsa oyuncuyu yukarı hareket ettir
    engelHizi = engelHiziMax; // Engellerin düşüş hızını artır
  }
  else {
    oyuncu.IleriGit(oyuncuDususHizi); // Basılmıyorsa aşağıya hareket ettir
    engelHizi = engelHiziMin; // Engellerin düşüş hızını azalt
  }
}


/* Ada Oluştur */
private final void EngelOlustur() { 
    /* 160 = width / 3 + (width / 3 - grafik.width) / 2 */
  int x;
  if (hizaIndex == 2) { // Eğer 3. engeli çıkartıyorsak
    do {
      x = 160 * ((int) random(0 , 3)); // Oluşacak adayı ekranda sağa, ortaya veya sola hizala
    }
    while(engelHiza[0] == engelHiza[1] && engelHiza[0] == x); // engel1 = engel2 = engel3 eşitliği bozulana kadar rastgele hiza seç
    
    engelHiza[0] = x; // 3. engeli hizala ve 1. engele dönüştür
    hizaIndex = 1; // Bir sonraki engel 2. engel olarak hizalanacak
    
  } else { // Eğer 1. veya 2. engeli çıkartıyorsak
    x = 160 * ((int) random(0 , 3)); // Oluşacak adayı ekranda sağa, ortaya veya sola hizala
    engelHiza[hizaIndex++] = x; // Engeli hizala ve bir sonraki engel 3. engel olarak hizalanacak
  }
   
  ada.add(new Engel(x, -99)); // Ekranın dışında ada oluştur (99 = grafik.height)
}


/* Adaları Ekranda Kaydır */
private final void EngelKaydir() {
  Engel tempAda;
  
  for(int i = 0; i < ada.size(); i++) { // Ekrandaki engel sayısı kadar döngü
    tempAda = ada.get(i); // Geçerli engeli değişkene aktar
    
    tempAda.Kaydir(engelHizi); // Engeli gereken hızda kaydır
    
    PuanKazan(tempAda); // Oyuncu engeli geçtiyse puan kazansın
    
    EngelCarpisma(tempAda); // Oyuncu engelle çarpıştıysa oyun bitsin
    
    /* Eğer bu engel daha önce klonlanmadıysa ve ekranda yeterince aşağı ulaşmışsa engeli klonla */
    if (!tempAda.Klonlanmis() && tempAda.getY() > oyuncu.getYukseklik() + 32) {
      EngelOlustur();     
      tempAda.Klonla();
    }
    else if (tempAda.getY() > height) { // Engel ekrandan çıkmışsa
      ada.remove(i); // Engeli sil
    }
  }
}


/* Geçilen Her Ada İçin Puan Al */
private final void PuanKazan(Engel _engel) {
  int oyuncuAltY = oyuncu.getY() + oyuncu.getYukseklik() / 2;
  
  /* Eğer bu engelden daha önce puan almadıysak ve oyuncuyu geçmişse puan ver */
  if (!_engel.PuanVermis() && _engel.getY() > oyuncuAltY) {
    if (oyuncuYukariGit)
      puan += oyuncuDikeyHizi * 2; // Oyuncu çok puan kazandı
    else
      puan += oyuncuDususHizi; // Oyuncu az puan kazandı
    
    _engel.PuanVer(); // Engelden gereken puan alındı
    
    if (oyuncuDikeyHizi < 5 && ++gecilenEngel > 20) { // Maksimum hıza ulaşılmamış ama 20'den fazla engel geçilmişse
      oyuncuDikeyHizi++;
      oyuncuDususHizi++;
      
      engelHiziMin = oyuncuDususHizi * 2;
      engelHiziMax = oyuncuDikeyHizi * 2;
      engelHizi = engelHiziMin;
      
      gecilenEngel = 0; // Hızı ve kazanılan puanı artır
      
      seviyeAtla = true; // Ekranda Daha Hızlı! mesajı göster
      seviyeGecisZamani = millis(); // Değişkeni şuanki zamana eşitle
    }
  }
}


/* Oyuncu Engelle Çarpıştı Mı Kontrol Et */
private final void EngelCarpisma(Engel _engel) {
  int engelX = _engel.getX();
  int engelY = _engel.getY() + 64;
  int engelX2 = engelX + _engel.getGenislik();
  int engelY2 = engelY + _engel.getYukseklik() - 64; // 38 piksel duyarsızlık payı bırak (adanın üstündeki otlar için)
  
  int oyuncuX = oyuncu.getX() + 52;
  int oyuncuY = oyuncu.getY() + 10;
  int oyuncuX2 = oyuncuX + oyuncu.getGenislik() - 92; // Sağ köşeden 52 sol köşeden 28 toplam 92 piksel duyarsızlık payı bırak
  int oyuncuY2 = oyuncuY + oyuncu.getYukseklik() - 20;

  /* Objeler Çarpışıyorsa */
  if (engelX < oyuncuX2 && engelX2 > oyuncuX && engelY < oyuncuY2 && engelY2 > oyuncuY) {
    music.stop(); // Müziği durdur
    oyunBitti = true; // Oyunu bitir
  }
    
}


/* Adaları Ekrana Çiz */
private final void EngelCiz() {
  for(Engel index : ada) { // Tüm engelleri
    index.Ciz(); // Ekrana çiz
  }
}


/* Arkaplanı Aşağı Doğru Kaydır */
private final void ArkaplanKaydir() {
  if (arkaplanY > height)
    arkaplanY = 0;
  else
    arkaplanY += engelHizi; // Arkaplanın sürekli kaymasını sağla
}


/* Oyunu Yeniden Başlat */
private final void OyunuYenidenBaslat() {
  
  ada.clear(); // Engel adaları ekrandan temizle 
  puan = 0; // Puanı sıfırla
  gecilenEngel = 0;
  hizaIndex = 0; // 2 tane üst üste aynı yerde engel gelebilir
  
  EngelOlustur(); // İlk engeli yarat  
  oyuncu.setKonum(180, 634); // Oyuncuyu başlangıç pozisyonuna götür
   
  oyuncuDikeyHizi = 2; 
  oyuncuDususHizi = 1; // Oyuncunun hareket hızını sıfırla
      
  engelHiziMin = oyuncuDususHizi * 2;
  engelHiziMax = oyuncuDikeyHizi * 2;
  engelHizi = engelHiziMin; // Engellerin kayma hızını ayarla
  
  music.loop(); // Arkaplan müziğini başlat 
  
  oyunBitti = false; // Oyun yeniden başladı
}


/* Denizi Çiz */
private final void ArkaplanCiz() {
  set(0, arkaplanY - height, arkaplan); // Birincil arkaplanı çiz
  set(0, arkaplanY, arkaplan); // İkincil arkaplanı çiz  
}


/* Seviye Atlandığında 1sn Boyunca Ekranda Uyarı Kalır */
private final void HizUyarisiYaz() {
  if (seviyeAtla & millis() - seviyeGecisZamani < 1000) { // Seviye atlanalı henüz 1 sn olmamışsa
    GolgeliYaz("DAHA HIZLI!", width / 2, 250);
  } else {
    seviyeAtla = false;
  }
}


/* Ekrana Gölge Efektli Yazı Yazdır */
private final void GolgeliYaz(String _text, int _x, int _y) {
    fill(0);
    text(_text, _x - 2, _y - 2);
    fill(255);
    text(_text, _x, _y);
}


final void draw() {  
  if (!oyunBitti) { // Oyun devam ediyorsa
    ArkaplanKaydir(); // Arkaplanı hareket ettir
    EngelKaydir(); // Engelleri hareket ettir & Çarpışma kontrolü yap
    GemiManevra(); // Oyuncuyu hareket ettir    
  }
  
  ArkaplanCiz(); // Oyun arkaplanını çiz
  EngelCiz(); // Engelleri çiz
  oyuncu.Ciz(); // Oyuncu objesini çiz 

  if (oyunBitti) { // Oyun bitmişse
    textAlign(CENTER, TOP);
    GolgeliYaz("Oyun Bitti!\nSkorun: " + puan, width / 2, 200); // Skor ekranını çıkar
    
    textAlign(RIGHT, BOTTOM);
    GolgeliYaz("R 'ye BAS", width - 20, height - 20); // Restart tuşunu yaz
    
  } else { // Devam ediyorsa
    textAlign(CENTER, TOP);
    GolgeliYaz(Integer.toString(puan), width / 2, 50); // Geçerli puanı yaz
    HizUyarisiYaz(); // Seviye atlandığında uyarı yap
  }
}