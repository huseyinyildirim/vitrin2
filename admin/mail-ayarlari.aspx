<%@ Page Language="C#" AutoEventWireup="true" CodeFile="mail-ayarlari.aspx.cs" Inherits="yonetim_Kullanici"
	EnableViewState="False" ViewStateMode="Disabled" EnableEventValidation="False" ValidateRequest="false" %>

<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-9" />
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
	<meta http-equiv="Content-Language" content="TR" />
	<meta http-equiv="Charset" content="iso-8859-9" />
	<meta http-equiv="Imagetoolbar" content="no" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta name="Robots" content="noindex,nofollow" />
	<title>Y�netici Paneli</title>
	<style media="all" type="text/css">
		@import url("css/sitil.css");
	</style>
	<script type="text/javascript">
<!--
		function NoError() {
			//alert("Sayfada JS hatas� olu�tu.\nL�tfen taray�c�y� kapat�p a�arak, yeniden deneyiniz");
			return (true);
		}
		onerror = NoError;
//-->
	</script>
	<ext:ResourcePlaceHolder ID="ResourcePlaceHolder1" runat="server" Mode="Script" />
</head>
<body>
	<script type="text/javascript">
		var FormKontrol = function () {
			if (!TextFieldKullaniciAdi.validate() || !TextFieldSifre.validate() || !TextFieldHost.validate() || !TextFieldPort.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'L�tfen zorunlu t�m alanlar� doldurun.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}
	</script>
	<form id="form1" runat="server">
	<ext:ResourceManager ID="ResourceManager1" runat="server" Theme="Gray" Locale="tr-TR"
		GZip="true" />
	<ext:Viewport ID="Viewport1" runat="server" Layout="FitLayout" StyleSpec="background-color:#F0F0F0">
		<Items>
			<ext:Window ID="Window1" runat="server" AnchorHorizontal="100%" AnchorVertical="100%"
				Icon="EmailEdit" Title="Mail Ayarlar�" Padding="5" Layout="FormLayout" ButtonAlign="Center"
				LabelSeparator=" : " Maximized="true" Closable="false" Minimizable="false">
				<Items>
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="TextFieldKullaniciAdi" Vtype="email" VtypeText="L�tfen ge�erli bir mail adresi giriniz" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z."
						runat="server" FieldLabel="Kullan�c� Ad�" BlankText="L�tfen kullan�c� ad�n� yaz�n." AnchorHorizontal="98%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="TextFieldSifre" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z."
						runat="server" FieldLabel="�ifre" BlankText="L�tfen �ifre yaz�n." AnchorHorizontal="98%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="TextFieldHost" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z."
						runat="server" FieldLabel="Host"  BlankText="L�tfen host bilgisini yaz�n." AnchorHorizontal="98%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="TextFieldPort" MaskRe="[0-9]" MaxLength="6" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z."
						runat="server" FieldLabel="Port" BlankText="L�tfen portu yaz�n." AnchorHorizontal="98%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
				</Items>
				<Buttons>
					<ext:Button ID="ButtonGuncelle" runat="server" Text="G�ncelle" Icon="Accept" Type="Submit">
						<Listeners>
							<Click Fn="FormKontrol" />
						</Listeners>
						<DirectEvents>
							<Click OnEvent="Guncelle">
								<EventMask ShowMask="true" Msg="G�ncelleniyor..." MinDelay="500" />
							</Click>
						</DirectEvents>
					</ext:Button>
				</Buttons>
				<DirectEvents>
				<BeforeRender OnEvent="Veriler" />
				</DirectEvents>
			</ext:Window>
		</Items>
	</ext:Viewport>
	</form>
</body>
</html>
