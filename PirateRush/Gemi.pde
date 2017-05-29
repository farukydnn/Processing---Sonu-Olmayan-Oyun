public class Gemi {
  
  private final PImage grafik = loadImage("gemi.png"); // Geminin grafiğini yükle
  
  private int x, y; // Geminin ekrandaki konumu
    
  private int ustLimit, altLimit; // Geminin ekranda yukarı ve aşağı hareket limiti
  private int solLimit = 0; // Geminin sola hareket limiti
  private int sagLimit = width - grafik.width; // Geminin sağa hareket limiti
  
  /* Gemiyi Tanımla */
  public Gemi(int _x, int _y, int _ustLimit, int _altLimit) {
    this.x = _x;
    this.y = _y;
    this.ustLimit = _ustLimit;
    this.altLimit = _altLimit;
  }  
  
  /* Gemiyi Yatay Düzlemde Hareket Ettir */
  public final void YanaGit(int _hiz) {
    x = constrain(x + _hiz, solLimit, sagLimit);
  }
  
  /* Gemiyi Dikey Düzlemde Hareket Ettir */
  public final void IleriGit(int _hiz) {
    y = constrain(y + _hiz, ustLimit, altLimit);
  }
  
  /* Geminin Grafik Genişliğini Döndür */
  public final int getGenislik() {
    return grafik.width;
  }
  
  /* Geminin Grafik Yüksekliğini Döndür */
  public final int getYukseklik() {
    return grafik.height;
  }
  
  /* Geminin X Konumunu Döndür */
  public final int getX() {
    return x;
  }
  
  /* Geminin Y Konumunu Döndür */
  public final int getY() {
    return y;
  }
  
  /* Geminin Konumunu Değiştir */
  public final void setKonum(int _x, int _y) {
    this.x = _x;
    this.y = _y;
  }
  
  /* Gemiyi Ekrana Çiz */
  public final void Ciz() {  
    image(grafik, x, y);  
  }
  
}