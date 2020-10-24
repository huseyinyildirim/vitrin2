<%@ Page Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="yonetim_default"
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
	<!--[if lt IE 7]>
<script type="text/javascript">window.location="tarayici.aspx"</script>
<![endif]-->
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
	<!--NOSCRIPT-->
	<noscript>
		<div id="noscript">
			<p>
				<u><b>Taray�c�n�z�n JavaScript deste�i bulunmamaktad�r.</b></u>
			</p>
			<p style="margin-top: 10px">
				Taray�c�n�z�n bu deste�inin olmay��� web sitemizi etkili bir �ekilde kullanamaman�z�
				sa�layacakt�r.</p>
			<p>
				L�tfen taray�c�n�zla ilgili gerekli ayarlar� yaparak sayfay� yenileyiniz.</p>
		</div>
	</noscript>
	<!--NOSCRIPT-->
	<script type="text/javascript">

		var GirisYap = function () {
			if (!txtUsername.validate() || !txtPassword.validate()) {
				Ext.Msg.show({ title: 'Hata', msg: 'L�tfen kullan�c� ad� ve �ifrenizi belirtiniz.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}

	</script>
	<form id="form1" runat="server">
	<ext:ResourceManager ID="ResourceManager1" runat="server" Theme="Gray" Locale="tr-TR"
		GZip="true" />
	<ext:Viewport ID="Viewport1" runat="server" Layout="FormLayout" Cls="default" StyleSpec="background-color: transparent;">
		<Items>
			<ext:Window ID="Window1" runat="server" Resizable="False" Icon="Lock" Title="Y�netici Giri�i"
				Width="350" Padding="5" Layout="FormLayout" ButtonAlign="Center" Shadow="Frame"
				LabelSeparator=" : " Draggable="true" AutoFocus="True" AutoHeight="True" Closable="false"
				Modal="false">
				<Items>
					<ext:TextField ID="txtUsername" runat="server" FieldLabel="Kullan�c� Ad�" MsgTarget="Side" AllowBlank="false"
						BlankText="L�tfen kullan�c� ad�n�z� giriniz." AnchorHorizontal="94%" />
					<ext:TextField ID="txtPassword" runat="server" InputType="Password" FieldLabel="�ifre"
						MsgTarget="Side" AllowBlank="false" BlankText="L�tfen �ifrenizi giriniz." AnchorHorizontal="94%" />
				</Items>
				<Buttons>
					<ext:Button ID="btnLogin" runat="server" Text="Giri�" Icon="Accept" Type="Submit">
						<Listeners>
							<Click Fn="GirisYap" />
						</Listeners>
						<DirectEvents>
							<Click OnEvent="GirisYap">
								<EventMask ShowMask="true" Msg="Do�rulan�yor..." MinDelay="500" />
							</Click>
						</DirectEvents>
					</ext:Button>
				</Buttons>
			</ext:Window>
		</Items>
	</ext:Viewport>
	</form>
</body>
</html>
