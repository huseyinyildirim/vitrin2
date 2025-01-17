﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySQLDataModel;
using System.Data.Linq.SqlClient;

public partial class _default : System.Web.UI.Page
{
    #region Int
    public int DilID; 
    #endregion

    #region String
    public string Detay { get; set; }
    public string ArananKelime { get; set; } 
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
            if (RouteData.Values["Kelime"] != null)
            {
                if (!string.IsNullOrEmpty(Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["Kelime"].ToString())))
                {
                    ArananKelime = Class.Fonksiyonlar.Genel.SQLTemizle(RouteData.Values["Kelime"].ToString());
                    Class.Fonksiyonlar.Uygulama.AramalaraEkle(DilID, ArananKelime);

                    Basliklar();
                }
                else
                {
                    Response.Redirect("/");
                }
            }
            else
            {
                Response.Redirect("/");
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
        Kategoriler = Class.Fonksiyonlar.Uygulama.Sag.Urunler.Kategoriler(DilID, 0); 
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

        #region Diğer Değişkenleri Yükle (Başlık vs. gibi)
        DigerYukle(); 
        #endregion

        #region Sayfa Yolu
        string Yol = Class.Fonksiyonlar.Genel.MevcutSayfa().Split('?')[0];
        #endregion
    }

    private void DigerYukle()
    {
        Detay = Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 3);
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

        Class.Fonksiyonlar.UserKontrol.HeaderText("basliklar", "baslik_sol", "<h1><img id=\"arrow1\" src=\"/images/arrow.png\" alt=\"\" class=\"arr\"/><a href=\"/" + Class.Fonksiyonlar.Genel.OzelAyar("URL") + "-products\">" + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 44) + "</a></h1>");

        #region Tüm Ürünler Bas
        SB.Append("<!--IC KATEGORI-->\r\n<ul>\r\n");
        SB.Append("<li><img src=\"/images/arrow.png\" alt=\"\"/> <span> " + ArananKelime.ToUpper() + "</span></li>");
        SB.Append("</ul>\r\n<!--IC KATEGORI-->\r\n");
        #endregion

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
                       }).Where(p => ((p.kod.StartsWith(ArananKelime.Substring(0, 1)) && p.kod.Contains(ArananKelime.Substring(ArananKelime.Length - 1, 1))) || ((p.ad.StartsWith(ArananKelime.Substring(0, 1)) && p.ad.Contains(ArananKelime.Substring(ArananKelime.Length - 1, 1))) || (p.aciklama.StartsWith(ArananKelime.Substring(0, 1)) && p.aciklama.Contains(ArananKelime.Substring(ArananKelime.Length - 1, 1))) || (p.on_aciklama.StartsWith(ArananKelime.Substring(0, 1)) && p.on_aciklama.Contains(ArananKelime.Substring(ArananKelime.Length - 1, 1))))));
            #endregion

            #region Ürün Sayfa Sayısından Küçükse
            if (SQL.AsEnumerable().Count() < sayfalamasp.PageSize)
            {
                sayfalama.Visible = false;
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

            if (SQL.Count() == 0)
            {
                litempty.Visible = true;
                litempty.Text = "<div id=\"bosarama\"><h3><img id=\"error1\" class=\"icon\" alt=\"\" src=\"/images/icon/error.png\"> " + Class.Fonksiyonlar.Uygulama.SabitlerText(Class.Fonksiyonlar.Dil.ID(), 47) + "</h3></div>";
            }
        }
    }

    protected void listeleme_Sorting(object sender, System.Web.UI.WebControls.ListViewSortEventArgs e)
    {
        Listele();
    }
}