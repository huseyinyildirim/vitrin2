﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySQLDataModel;
using System.Web.Routing;

public partial class products : System.Web.UI.Page
{
    #region Int
    public int DilID;
    public int KategoriID { get; set; }
    public int BaslikTip;
    #endregion

    #region String
    public string Marka { get; set; }
    public string Etiket { get; set; }
    public string Detay { get; set; } 
    #endregion

    #region List
    public List<string> Keywords = new List<string>();
    public List<string> Etiketler = new List<string>();
    public List<string> Markalar = new List<string>();
    public List<string> UrunKodlari = new List<string>();
    public List<string> UrunAdlari = new List<string>(); 
    #endregion

    #region Dictionary
    public Dictionary<int, string> Kategoriler = new Dictionary<int, string>(); 
    #endregion

    #region Class
    public static class SiralamaIsleri
    {
        #region String
        public static string Kolon { get; set; }
        public static string Direktif { get; set; } 
        #endregion

        #region Void
        public static void HadiSirala()
        {
            if (Class.Fonksiyonlar.Genel.StringTemizle(HttpContext.Current.Request.QueryString["k"]) != null)
            {
                Kolon = Class.Fonksiyonlar.Genel.StringTemizle(HttpContext.Current.Request.QueryString["k"]);
            }

            if (Class.Fonksiyonlar.Genel.StringTemizle(HttpContext.Current.Request.QueryString["d"]) != null)
            {
                Direktif = Class.Fonksiyonlar.Genel.StringTemizle(HttpContext.Current.Request.QueryString["d"]).ToUpper();
            }
        } 
        #endregion
    } 
    #endregion

    #region VIEWSTATE Serializer

    private ViewStateSerializer.ViewStateSerializer _persister = null;
    protected override PageStatePersister PageStatePersister
    {
        get
        {
            if (_persister == null)
            {
                _persister = new ViewStateSerializer.ViewStateSerializer(Page, ViewStateSerializer.ViewStateSerializer.SecurityLevel.Low, false);
                //_persister.CompressPage(); // optional (compress all output HTML page) if have problems, comment it
            }
            return _persister;
        }
    }
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        #region Dil ID
        DilID = Class.Fonksiyonlar.Dil.ID(); 
        #endregion

        #region JS ile CSS Ayar
        //Class.Fonksiyonlar.JavaScript.Ekle("$(function () {if ($('#cleft').height() < $('#cright').height()){$('#cleft').css({'min-height' : $('#cright').height()+50})};});\r\n");
        #endregion

        #region QueryString Al
        if (!IsPostBack)
        {
            if (RouteData.Values["CategoriID"] != null)
            {
                if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["CategoriID"].ToString())))
                {
                    if (Class.Fonksiyonlar.Genel.Kontroller.Numerik(Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["CategoriID"].ToString().Split('-')[0])))
                    {
                        KategoriID = Convert.ToInt16(Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["CategoriID"].ToString().Split('-')[0]));
                        BaslikTip = (int)Class.Sabitler.Ziyaret.KATEGORI;
                    }
                }
            }
        }

        if (!IsPostBack)
        {
            if (RouteData.Values["Tag"] != null)
            {
                if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["Tag"].ToString())))
                {
                    Etiket = Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["Tag"].ToString());
                    BaslikTip = (int)Class.Sabitler.Ziyaret.ETIKET;
                }
            }
        }

        if (!IsPostBack)
        {
            if (RouteData.Values["Brand"] != null)
            {
                if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["Brand"].ToString())))
                {
                   Marka = Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["Brand"].ToString());
                   BaslikTip = (int)Class.Sabitler.Ziyaret.MARKA;
                }
            }
        }
        #endregion

        #region Description Metatag
        Class.Fonksiyonlar.UserKontrol.HeaderText("sitil", "description", "<meta http-equiv=\"Description\" content=\"" + Class.Fonksiyonlar.Firma.Description() + "\" />");
        #endregion

        #region Ürün Listeleme
        Listele(); 
        #endregion

        #region Kategorileri Al
        if (KategoriID == 0)
        {
            Kategoriler = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Kategoriler(DilID, 0);
        }
        else
        {
            Kategoriler = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Kategoriler(DilID, KategoriID);

            if (Kategoriler.Count < 1)
            {
                Kategoriler = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Kategoriler(DilID, 0);
            }
        }
        #endregion

        #region Kategorileri Bas
        Class.Fonksiyonlar.Uygulama.Sag.Icerik.Kategoriler(Kategoriler);
        #endregion

        #region Markalari Al
        Markalar = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Markalar();
        #endregion

        #region Markalari Bas
        Class.Fonksiyonlar.Uygulama.Sag.Icerik.Markalar(Markalar);
        #endregion

        #region Etiketleri Al
        Etiketler = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Etiketler(DilID); 
        #endregion

        #region Etiketleri Bas
        Class.Fonksiyonlar.Uygulama.Sag.Icerik.Etiketler(Etiketler);
        #endregion

        #region Keywords Bas
        KeywordsBas(); 
        #endregion

        #region Sıralama Yap
        SiralamaIsleri.HadiSirala(); 
        #endregion

        #region Diğer Değişkenleri Yükle (Başlık vs. gibi)
        Basliklar();
        DigerYukle(); 
        #endregion

        #region Tanımlamalar ve Atamalar (Sorting için HyperLink ve Image)

        HyperLink link1 = (HyperLink)Page.FindControl("HyperLink1");
        HyperLink link2 = (HyperLink)Page.FindControl("HyperLink2");
        Image imaj1 = (Image)Page.FindControl("Image1");
        Image imaj2 = (Image)Page.FindControl("Image2");

        string sayfa = Request.QueryString["s"];

        if (sayfa == null)
        {
            sayfa = "1";
        }

        #endregion Tanımlamalar

        #region Sayfa Yolu
        string Yol = Class.Fonksiyonlar.Genel.MevcutSayfa().Split('?')[0];
        #endregion

        #region Ada Göre Sırala

        if (SiralamaIsleri.Kolon == "a" && SiralamaIsleri.Direktif == "D")
        {
            imaj1.ImageUrl = "~/images/arrow-bottom.png";
            link1.ToolTip = "Ürün adına göre artan olarak sırala";
            link1.NavigateUrl =  Yol + "?k=a&d=A&s=" + sayfa;
        }
        else if (SiralamaIsleri.Kolon == "a" && SiralamaIsleri.Direktif == "A")
        {
            imaj1.ImageUrl = "~/images/arrow-top.png";
            link1.ToolTip = "Ürün adına göre azalan olarak sırala";
            link1.NavigateUrl = Yol + "?k=a&d=D&s=" + sayfa;
        }
        else
        {
            imaj1.ImageUrl = "~/images/blank.gif";
            link1.ToolTip = "Ürün adına göre azalan olarak sırala";
            link1.NavigateUrl = Yol + "?k=a&d=D&s=" + sayfa;
        }

        #endregion Ada Göre Sırala

        #region Koda Göre Sırala

        if (SiralamaIsleri.Kolon == "k" && SiralamaIsleri.Direktif == "D")
        {
            imaj2.ImageUrl = "~/images/arrow-top.png";
            link2.ToolTip = "Ürün koduna göre artan olarak sırala";
            link2.NavigateUrl = Yol + "?k=k&d=A&s=" + sayfa;
        }
        else if (SiralamaIsleri.Kolon == "k" && SiralamaIsleri.Direktif == "A")
        {
            imaj2.ImageUrl = "~/images/arrow-bottom.png";
            link2.ToolTip = "Ürün koduna göre azalan olarak sırala";
            link2.NavigateUrl = Yol + "?k=k&d=D&s=" + sayfa;
        }
        else
        {
            imaj2.ImageUrl = "~/images/blank.gif";
            link2.ToolTip = "Ürün koduna göre azalan olarak sırala";
            link2.NavigateUrl = Yol + "?k=k&d=D&s=" + sayfa;
        }

        #endregion Koda Göre Sırala

        KodScriptEkle();
    }

    private void KodScriptEkle()
    {
        if (((Route)(RouteData.Route))!=null)
        {
            string kod = Class.Fonksiyonlar.Uygulama.KodScriptYaz(DilID, ((Route)(RouteData.Route)).Url);

            if (!string.IsNullOrEmpty(kod))
            {
                litkod.Text = kod;
            }
        }
    }

    private void Basliklar()
    {
        #region Başlık Sol

        #region Sol Başlık Visibility
        Class.Fonksiyonlar.UserKontrol.ElemanGizle(0, "basliklar", "baslik_sol", true);
        #endregion

        #region Literal Al
        UserControl UC = (UserControl)((Page)HttpContext.Current.Handler).FindControl("basliklar");
        Literal Li = UC.FindControl("ic_kategori") as Literal;
        #endregion

        StringBuilder SB = new StringBuilder();

        switch (BaslikTip)
        {
            case (int)Class.Sabitler.Ziyaret.ETIKET:
                Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sol", "<h1><img id=\"arrow1\" src=\"/images/arrow.png\" alt=\"\" class=\"arr\"/><a href=\"/" + Class.Fonksiyonlar.Genel.OzelAyar("URL") + "-products\">" + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 41) + "</a></h1>");

                #region Etiket Bas
                SB.Append("<!--IC KATEGORI-->\r\n<ul>\r\n");
                SB.Append("<li><img src=\"/images/arrow.png\" alt=\"\"/> <span>" + Etiket.ToUpper() + "</span></li>");
                SB.Append("</ul>\r\n<!--IC KATEGORI-->\r\n");
                #endregion

                break;

            case (int)Class.Sabitler.Ziyaret.KATEGORI:
                Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sol", "<h1><img id=\"arrow1\" src=\"/images/arrow.png\" alt=\"\" class=\"arr\"/><a href=\"/" + Class.Fonksiyonlar.Genel.OzelAyar("URL") + "-products\">" + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 42) + "</a></h1>");

                #region Kategorileri Bas
                SB.Append("<!--IC KATEGORI-->\r\n<ul>\r\n");
                SB.Append(Nerdesin(KategoriID.ToString()));
                SB.Append("</ul>\r\n<!--IC KATEGORI-->\r\n");
                #endregion

                break;

            case (int)Class.Sabitler.Ziyaret.MARKA:
                Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sol", "<h1><img id=\"arrow1\" src=\"/images/arrow.png\" alt=\"\" class=\"arr\"/><a href=\"/" + Class.Fonksiyonlar.Genel.OzelAyar("URL") + "-products\">" + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 43) + "</a></h1>");

                #region Marka Bas
                SB.Append("<!--IC KATEGORI-->\r\n<ul>\r\n");
                SB.Append("<li><img src=\"/images/arrow.png\" alt=\"\"/> <span>" + Marka.ToUpper() + "</span></li>");
                SB.Append("</ul>\r\n<!--IC KATEGORI-->\r\n");
                #endregion

                break;

            default:
                Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sol", "<h1><img id=\"arrow1\" src=\"/images/arrow.png\" alt=\"\" class=\"arr\"/><a href=\"/" + Class.Fonksiyonlar.Genel.OzelAyar("URL") + "-products\">" + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 17) + "</a></h1>");

                #region Tüm Ürünler Bas
                SB.Append("<!--IC KATEGORI-->\r\n<ul>\r\n");
                SB.Append("<li><img src=\"/images/arrow.png\" alt=\"\"/> <span>" + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 44).ToUpper() + "</span></li>");
                SB.Append("</ul>\r\n<!--IC KATEGORI-->\r\n");
                #endregion

                break;
        }

        #region Literal Göster
        Li.Text = SB.ToString();
        Li.Visible = true;
        #endregion

        #endregion

        #region Başlık Sağ

        #region Sağ Başlık Visibility
        Class.Fonksiyonlar.UserKontrol.ElemanGizle(0, "basliklar", "baslik_sag", true);
        #endregion

        #region Başlık Text
        StringBuilder SB1 = new StringBuilder();
        SB1.Append("<!--SAG BASLIK-->\r\n");
        SB1.Append("<div id=\"basr\"><h1><img id=\"mail1\" src=\"/images/icon/lorry.png\" alt=\"\" class=\"icon\"/> " + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 17) + "</h1></div>\r\n");
        SB1.Append("<!--SAG BASLIK-->\r\n");
        #endregion

        Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sag", SB1.ToString());

        #endregion
    }

    private string Nerdesin(string ID)
    {
        using (BaglantiCumlesi SME = new BaglantiCumlesi())
        {
            int GelenID = Convert.ToInt16(ID);

            var SQL = (from p in SME.tbl_kategoriler
                       where p.dil_id == DilID && p.onay == true && p.id == GelenID
                       select p);

            StringBuilder SB1 = new StringBuilder();

            foreach (var i in SQL)
            {
                StringBuilder SB2 = new StringBuilder();
                SB2.Append("<li>");

                SB2.Append("<img src=\"/images/arrow.png\" alt=\"\"/> ");

                if (KategoriID != GelenID)
                {
                    SB2.Append("<a href=\"/categori/");
                    SB2.Append(i.id + "-" + Class.Fonksiyonlar.Genel.KarakterTemizle(i.ad,true));
                    SB2.Append("\">");
                }

                if (KategoriID != GelenID)
                {
                    SB2.Append(i.ad);
                }
                else
                {
                    SB2.Append("<span>" + i.ad + "</span>");
                }

                if (KategoriID != GelenID)
                {
                    SB2.Append("</a>");
                }

                SB2.Append("</li>\r\n");

                SB1.Append(Nerdesin(i.kategori_id.ToString()));
                SB1.Append(SB2.ToString());
            }

            return SB1.ToString();
        }
    }

    private void DigerYukle()
    {
        Hyperlink1.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 1);
        Hyperlink2.Text = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 2);
        Detay = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 3);
    }

    private void KeywordsBas()
    {
        #region Kategorileri Keywordse Ekle
        Keywords.AddRange(new List<string>(Kategoriler.Values));
        #endregion

        #region Markaları Keywordse Ekle
        Keywords.AddRange(Markalar);
        #endregion

        #region Etiketleri Keywordse Ekle
        Keywords.AddRange(Etiketler);
        #endregion

        #region Ürün Kodlarını Keywordse Ekle
        Keywords.AddRange(UrunKodlari);
        #endregion

        #region Ürün Adlarını Keywordse Ekle
        Keywords.AddRange(UrunAdlari);
        #endregion

        #region Keywordsler İçinde Aynı Kayıtlar Varsa Sil
        List<string> L = Keywords.Distinct().ToList().ConvertAll(x => Class.Fonksiyonlar.Genel.TurkceKarakter(x.ToString().ToLower())); 
        #endregion

        #region Listeden Keywordsleri Al
        StringBuilder SB2 = new StringBuilder();

        int a = 0;

        foreach (var i in L)
        {
            if (a != L.Count - 1)
            {
                SB2.Append(i + ",");
            }
            else
            {
                SB2.Append(i);
            }

            a++;
        }

        if (!string.IsNullOrEmpty(SB2.ToString()))
        {
            if (SB2.ToString().Substring(SB2.ToString().Length - 1, 1) == ",")
            {
                SB2.Append(Class.Fonksiyonlar.Firma.Title());
            }
        }
        #endregion

        #region Keywords Metatag
        Class.Fonksiyonlar.UserKontrol.HeaderText("sitil", "keywords", "<meta http-equiv=\"Keywords\" content=\"" + SB2.ToString().Replace(", ", ",").Replace(",",", ") + "\" />");
        #endregion
    }

    protected void Listele()
    {
        using (BaglantiCumlesi SME = new BaglantiCumlesi())
        {
            #region SQL String
            string marka = Class.Fonksiyonlar.Firma.Marka().ToLower();
            var SQL = (from p in SME.tbl_urunler
                       where p.dil_id == DilID && p.onay == true
                       let LKod = SME.tbl_kodlar.Where(k => k.id == p.kod_id).Select(x => x.kod).FirstOrDefault()
                       select new
                       {
                           ad = p.ad,
                           p.aciklama,
                           p.id,
                           p.on_aciklama,
                           p.resim_id,
                           kod = (LKod != null ? LKod : null),
                           marka = (LKod != null ? LKod : marka)
                       });
            #endregion

            #region Kategori Olayı
            if (KategoriID != 0)
            {
                #region Gelen Kategori "Tüm Kategoriler" değilse
                if (KategoriID != -1)
                {
                    List<int> E;

                    var SQL2 = (from p in SME.tbl_urunler_kategoriler
                                where p.kategori_id == KategoriID
                                select
                                new
                                {
                                    p.urun_id
                                });

                    E = new List<int>(SQL2.ToList().ConvertAll(d => d.urun_id).ToList());

                    SQL = SQL.Where(s => E.Contains(s.id));

                    #region Ziyaret Ekle
                    Class.Fonksiyonlar.Uygulama.ZiyaretEkle((int)Class.Sabitler.Ziyaret.KATEGORI, KategoriID);
                    #endregion
                } 
                #endregion
            }
            #endregion

            #region Etiket Olayı
            if (Etiket != null)
            {
                List<int?> E = new List<int?>();

                var SQL2 = (from p in SME.tbl_etiketler
                            where p.ad.StartsWith(Etiket.Substring(0, 1)) && p.ad.Contains(Etiket.Substring(Etiket.Length - 1, 1)) && p.dil_id == DilID && p.onay == true
                            select
                            new
                            {
                                p.id
                            });

                foreach (var i in SQL2)
                {
                    E.Add(i.id);
                }

                List<int> U;

                var SQL3 = (from p in SME.tbl_urunler_etiketler
                            where E.Contains(p.etiket_id)
                            select
                            new
                            {
                                uid = p.urun_id
                            });

                U = new List<int>(SQL3.ToList().ConvertAll(d => d.uid).ToList());

                SQL = SQL.Where(s => U.Contains(s.id));

                #region Ziyaret Ekle
                Class.Fonksiyonlar.Uygulama.ZiyaretEkle((int)Class.Sabitler.Ziyaret.ETIKET, SQL2.Select(x => x.id).FirstOrDefault());
                #endregion
            }
            #endregion

            #region Marka Olayı
            if (Marka != null)
            {
                #region Gelen Marka "TÜM MARKALAR" değilse
                if (Marka != Class.Fonksiyonlar.Genel.KarakterTemizle(Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 40),false))
                {
                    List<int?> M = new List<int?>();

                    var SQL4 = (from p in SME.tbl_markalar
                                where p.ad.StartsWith(Marka.Substring(0, 1)) && p.ad.Contains(Marka.Substring(Marka.Length - 1, 1)) && p.onay == true
                                select
                                new
                                {
                                    p.id
                                });

                    foreach (var i in SQL4)
                    {
                        M.Add(i.id);
                    }

                    List<int> U2;

                    var SQL5 = (from p in SME.tbl_urunler_markalar
                                where M.Contains(p.marka_id)
                                select
                                new
                                {
                                    uid = p.urun_id
                                });

                    U2 = new List<int>(SQL5.ToList().ConvertAll(d => d.uid).ToList());

                    SQL = SQL.Where(s => U2.Contains(s.id));

                    #region Ziyaret Ekle
                    Class.Fonksiyonlar.Uygulama.ZiyaretEkle((int)Class.Sabitler.Ziyaret.MARKA, SQL4.Select(x => x.id).FirstOrDefault());
                    #endregion
                } 
                #endregion
            }
            #endregion

            #region Ürün Sayfa Sayısından Küçükse
            if (SQL.AsEnumerable().Count() < sayfalamasp.PageSize)
            {
                sayfalama.Visible = false;
            } 
            #endregion

            #region Siralama İşlemleri
            if (SiralamaIsleri.Direktif != null)
            {
                if (SiralamaIsleri.Direktif == "D")
                {
                    if (SiralamaIsleri.Kolon != null)
                    {
                        if (SiralamaIsleri.Kolon == "a")
                        {
                            SQL = SQL.OrderBy(n => n.ad).OrderByDescending(n => n.ad);
                        }
                        else if (SiralamaIsleri.Kolon == "k")
                        {
                            SQL = SQL.OrderBy(n => n.kod).OrderByDescending(n => n.kod);
                        }
                    }
                }
                else if (SiralamaIsleri.Direktif == "A")
                {
                    if (SiralamaIsleri.Kolon != null)
                    {
                        if (SiralamaIsleri.Kolon == "a")
                        {
                            SQL = SQL.OrderBy(n => n.ad);
                        }
                        else if (SiralamaIsleri.Kolon == "k")
                        {
                            SQL = SQL.OrderBy(n => n.kod);
                        }
                    }
                }
            } 
            #endregion

            #region Ürün Kodlarını Listeye At
            UrunKodlari = SQL.Where(x => x.kod != null).Select(x => x.kod).ToList();
            #endregion

            #region Ürün Adlarını Listeye At
            UrunAdlari = SQL.AsEnumerable().Select(x => x.ad).ToList();
            #endregion

            #region DataBind
            listeleme.DataSource = SQL;
            listeleme.DataBind(); 
            #endregion
        }
    }

    protected void listeleme_Sorting(object sender, System.Web.UI.WebControls.ListViewSortEventArgs e)
    {
        Listele();
    }
}