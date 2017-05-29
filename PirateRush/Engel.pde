public class Engel {
 
  private final PImage grafik = loadImage("engel.png"); // Engelin grafiğini yükle
  
  private int x, y; // Engelin ekrandaki konumu
  private boolean klonlandi = false; // Engel henüz başka bir engeli oluşturmadı
  private boolean puanVerildi = false; // Engel henüz oyuncuya puan kazandırmadı
  
  /* Engeli Tanımla */
  public Engel(int _x, int _y) {
    this.x = _x;
    this.y = _y;
  }
  
  /* Engeli Ekranda Kaydır */
  public final void Kaydir(int _hiz) {
    y += _hiz;
  }
  
  /* Engelin Y Konumunu Döndür */
  public final int getY() {
    return y;
  }
  
  /* Engelin X Konumunu Döndür */
  public final int getX() {
    return x;
  }
  
  /* Engelin Genişliğini Döndür */
  public final int getGenislik() {
    return grafik.width;
  }
  
  /* Engelin Yüksekliğini Döndür */
  public final int getYukseklik() {
    return grafik.height;
  }
  
  /* Bu Objenin Klonlanabilir Olup Olmadığı Bilgisini Gönder */
  public final boolean Klonlanmis() {
    return klonlandi;
  }
  
  /* Objeyi Klonlanmış Konuma Getir */
  public final void Klonla() {
    klonlandi = true;
  }
  
    /* Bu Objenin Oyuncuya Önceden Puan Verip Vermediği Bilgisini Gönder */
  public final boolean PuanVermis() {
    return puanVerildi;
  }
  
  /* Obje Oyuncuya Puan Verdi */
  public final void PuanVer() {
    puanVerildi = true;
  }
  
  /* Engeli Ekrana Çiz */
  public final void Ciz() {
    image(grafik, x, y); 
  }
  
}