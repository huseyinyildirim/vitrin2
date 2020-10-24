<%@ Page Language="C#" AutoEventWireup="true" CodeFile="firma-bilgileri.aspx.cs" Inherits="yonetim_Kullanici"
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
			if (!TextFieldFirma.validate() || !TextFieldMarka.validate() || !TextFieldDomain.validate() || !TextFieldMail.validate() || !TextAreaDescription.validate() || !TextAreaTitle.validate()) {
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
				Icon="VcardEdit" Title="Firma Bilgileri" Padding="5" Layout="FormLayout" ButtonAlign="Center"
				LabelSeparator=" : " Maximized="true" Closable="false" Minimizable="false" AutoScroll="true">
				<Items>
				<ext:Panel ID="PanelCollapsedFirmaBilgileri" runat="server" Title="Firma Bilgileri"
						FormGroup="true" Layout="FormLayout" Padding="5" StyleSpec="margin-bottom:5px;background:#fff;border:1px solid #C3DAF9" LabelSeparator=" : " AnchorHorizontal="99%">
						<Content>
						<ext:TextArea MsgTarget="Side" AllowBlank="false" Height="60" ID="TextAreaUnvan" runat="server" FieldLabel="Tam �nvan"
						BlankText="L�tfen firma tam �nvan�n� yaz�n." AnchorHorizontal="98%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="TextFieldFirma" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z."
						runat="server" FieldLabel="Ad� (K�sa)" BlankText="L�tfen firma ad�n� yaz�n." AnchorHorizontal="98%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="TextFieldMarka" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z."
						runat="server" FieldLabel="Marka" BlankText="L�tfen markan�z� yaz�n." AnchorHorizontal="98%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" EnableKeyEvents="true">
						<Listeners>
							<KeyUp Handler="this.setValue(this.getValue().toLowerCase());" />
						</Listeners>
						</ext:TextField>
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="TextFieldDomain" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z."
						runat="server" FieldLabel="Domain" BlankText="L�tfen alan ad�n�z� yaz�n." AnchorHorizontal="98%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan"	EnableKeyEvents="true">
						<Listeners>
							<KeyUp Handler="this.setValue(this.getValue().toLowerCase());" />
						</Listeners>
						</ext:TextField>
					<ext:TextField MsgTarget="Side" AllowBlank="false" ID="TextFieldMail" Vtype="email" VtypeText="L�tfen ge�erli bir mail adresi giriniz" MaxLength="320" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z."
						runat="server" FieldLabel="Mail" BlankText="L�tfen mail adresinizi yaz�n." AnchorHorizontal="98%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" 	EnableKeyEvents="true">
						<Listeners>
							<KeyUp Handler="this.setValue(this.getValue().toLowerCase());" />
						</Listeners>
						</ext:TextField>
					<ext:TextArea MsgTarget="Side" AllowBlank="false" Height="120" ID="TextAreaDescription" runat="server"
						FieldLabel="Tan�mlama" BlankText="L�tfen sayfa i�in tan�mla yaz�n." AnchorHorizontal="98%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
					<ext:TextArea MsgTarget="Side" AllowBlank="false" Height="120" ID="TextAreaTitle" runat="server" FieldLabel="Sayfa Ba�l���"
						BlankText="L�tfen sayfa i�in title (ba�l�k) yaz�n." AnchorHorizontal="98%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" />
						</Content>
						</ext:Panel>
						<ext:Panel ID="PanelCollapsedSosyalAglar" Collapsed="true" runat="server" Title="Sosyal A�lar"
						FormGroup="true" Layout="FormLayout" Padding="5" StyleSpec="margin-bottom:5px;background:#fff;border:1px solid #C3DAF9" LabelSeparator=" : " AnchorHorizontal="99%">
						<Content>
						<ext:TextField ID="TextFieldFlickr_ID" runat="server" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z." FieldLabel="Flickr ID" AnchorHorizontal="98%"/>
						<ext:TextField ID="TextFieldYoutube_ID" runat="server" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z." FieldLabel="Youtube ID" AnchorHorizontal="98%"/>
						<ext:TextField ID="TextFieldVimeo_ID" runat="server" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z." FieldLabel="Vimeo ID" AnchorHorizontal="98%"/>
						<ext:TextField ID="TextFieldFacebook_ID" runat="server" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z." FieldLabel="Facebook ID" AnchorHorizontal="98%"/>
						<ext:TextField ID="TextFieldGooglePlus_ID" runat="server" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z." FieldLabel="Google Plus ID" AnchorHorizontal="98%"/>
						<ext:TextField ID="TextFieldTwitter_ID" runat="server" MaxLength="255" MaxLengthText="Maksimum karakter s�n�r�n� a�t�n�z." FieldLabel="Twitter ID" AnchorHorizontal="98%"/>
						</Content>
						</ext:Panel>
						<ext:Panel ID="PanelCollapsedDigerBilgiler" Collapsed="true" runat="server" Title="Google Analytics"
						FormGroup="true" Layout="FormLayout" Padding="5" StyleSpec="margin-bottom:5px;background:#fff;border:1px solid #C3DAF9" LabelSeparator=" : " AnchorHorizontal="99%">
						<Content>
						<ext:TextArea Height="120" ID="TextAreaGoogleAnalytics" runat="server" FieldLabel="JS Kodu" AnchorHorizontal="98%"/>
						</Content>
						</ext:Panel>

						<ext:Panel ID="PanelCollapsedDigerBilgiler2" Collapsed="true" runat="server" Title="Google Do�rulama Kodu"
						FormGroup="true" Layout="FormLayout" Padding="5" StyleSpec="background:#fff;border:1px solid #C3DAF9" LabelSeparator=" : " AnchorHorizontal="99%">
						<Content>
						<ext:TextField ID="TextAreaGoogleDogrulamaKodu" runat="server" FieldLabel="Meta Kodu" AnchorHorizontal="98%"/>
						</Content>
						</ext:Panel>
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
