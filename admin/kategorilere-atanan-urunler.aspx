<%@ Page Language="C#" AutoEventWireup="true" CodeFile="kategorilere-atanan-urunler.aspx.cs" Inherits="yonetim_Kullanici"
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
		Ext.data.Connection.override({
			timeout: 300000
		});

		Ext.Ajax.timeout = 300000;

		var ExportYap = function () {
			Ext.net.Mask.show();
			Ext.net.Mask.hide.defer(500);
		};

		var WindowEkleClear = function () {
			for (var i = 0; i <= WindowEkle.items.items.length; i++) {
				if (WindowEkle.items.items[i].xtype == "combo") {
					WindowEkle.items.items[i].clear();
				}
				else if (WindowEkle.items.items[i].xtype == "netdropdown") {
					Ekle_KategorilerNodeTemizle();
					WindowEkle.items.items[i].clear();
				}
			}
		}

		var WindowDuzenleClear = function () {
			for (var i = 0; i <= WindowDuzenle.items.items.length; i++) {
				if (WindowDuzenle.items.items[i].xtype == "combo") {
					WindowDuzenle.items.items[i].clear();
				}
				else if (WindowDuzenle.items.items[i].xtype == "netdropdown") {
					Duzenle_KategorilerNodeTemizle();
					WindowDuzenle.items.items[i].clear();
				}
				else {
					Duzenle_ChecboxKategori.clear();
				}
			}
		}

		var DuzenleKontrol = function () {
			if (Duzenle_ChecboxKategori.getValue()) {
				if (Duzenle_DropDownFieldKategoriler.getValue() == "Kategori Se�iniz..." || Duzenle_DropDownFieldKategoriler.getValue() == "[]" || Duzenle_DropDownFieldKategoriler.getValue() == "") {
					Ext.Msg.show({ title: 'Hata', msg: 'L�tfen bir Kategori se�in.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
					return false;
				}
			}
			else if (Duzenle_ComboBoxUrun.getSelectedIndex() == -1) {
				Ext.Msg.show({ title: 'Hata', msg: 'L�tfen bir �r�n se�iniz.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}

		var KaydetKontrol = function () {
			if (Ekle_DropDownFieldKategoriler.getValue() == "Kategori Se�iniz..." || Ekle_DropDownFieldKategoriler.getValue() == "[]" || Ekle_DropDownFieldKategoriler.getValue() == "") {
				Ext.Msg.show({ title: 'Hata', msg: 'L�tfen bir Kategori se�in.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
			else if (Ekle_ComboBoxUrun.getSelectedIndex() == -1) {
				Ext.Msg.show({ title: 'Hata', msg: 'L�tfen bir �r�n se�iniz.', buttons: Ext.Msg.OK, icon: Ext.Msg.ERROR });
				return false;
			}
		}

		var GridKomutlari = function (cmd, record) {
			switch (cmd) {

				case "IslemKaydi":

					var win = new Ext.Window({
						id: 'WindowY' + record.data.id,
						iconCls: "icon-usercomment",
						title: '��lem Kay�tlar�n� G�sterim Penceresi - ' + record.data.id,
						closable: false,
						width: 640,
						height: 480,
						resizable: true,
						renderTo: Ext.getBody(),
						maximizable: true,
						minimizable: false,
						modal: false,
						layout: 'fit',
						autoLoad: {
							maskMsg: "��lem kay�tlar� y�kleniyor...",
							showMask: true,
							mode: "iframe",
							url: "isleme-ait-kayitlar.aspx?tablo_adi=tbl_urunler_kategoriler&kayit_id=" + record.data.id,
							scripts: true
						},
						buttonAlign: 'right',
						buttons: [
			{
				iconCls: "icon-cancel",
				text: 'KAPAT',
				handler: function () {
					win.close();
				}
			}
		]
					});

					win.show();

					break;

				case "Sil":
					Ext.Msg.confirm('Uyar�', 'Se�ilen Kayd� Sil?', function (btn) {
						if (btn == "yes") {
							Store1.remove(record);
							Store1.save();
						}
					});
					break;

				case "Duzenle":
					Ext.net.DirectMethods.GuncellemeEkraniGetir(record.data.id);
					break;
			}
		}

		function Ekle_NodeYukleKategoriler(node) {
			Ext.net.DirectMethods.Ekle_NodeYukleKategoriler(node.id, {
				success: function (result) {
					var data = eval("(" + result + ")");
					node.loadNodes(data);
				},

				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}

		var Ekle_KategorilerEkle = function (tree) {
			var msg = [],
				selNodes = tree.getChecked();

			Ext.each(selNodes, function (node) {
				if (msg.length > 1) {
					msg.push(",");
				}

				msg.push(node.text);
			});

			return msg.join("");
		};

		var Ekle_KategorilerNodeTemizle = function () {
			Ekle_TreePanelKategoriler.getRootNode().cascade(function (n) {
				var ui = n.getUI();
				ui.toggleCheck(false);
			});
		}

		function Duzenle_NodeYukleKategoriler(node) {
			Ext.net.DirectMethods.Duzenle_NodeYukleKategoriler(node.id, {
				success: function (result) {
					var data = eval("(" + result + ")");
					node.loadNodes(data);
				},

				failure: function (errorMsg) {
					Ext.Msg.alert('Hata', errorMsg);
				}
			});
		}

		var Duzenle_KategorilerEkle = function (tree) {
			var msg = [],
				selNodes = tree.getChecked();

			Ext.each(selNodes, function (node) {
				if (msg.length > 1) {
					msg.push(",");
				}

				msg.push(node.text);
			});

			return msg.join("");
		};

		var Duzenle_KategorilerNodeTemizle = function () {
			Duzenle_TreePanelKategoriler.getRootNode().cascade(function (n) {
				var ui = n.getUI();
				ui.toggleCheck(false);
			});
		}

		var Duzenle_KategoriDegistir = function () {
			if (Duzenle_ChecboxKategori.getValue()) {
				Duzenle_DropDownFieldKategoriler.setDisabled(false);
				Duzenle_DropDownFieldKategoriler.AllowBlank(true);
			}
			else {
				Duzenle_DropDownFieldKategoriler.setDisabled(true);
				Duzenle_DropDownFieldKategoriler.AllowBlank(false);
			}
		}
	</script>
	<form id="form1" runat="server">
	<ext:ResourceManager ID="ResourceManager1" runat="server" Theme="Gray" Locale="tr-TR"
		GZip="true" />
	<ext:Viewport ID="Viewport1" runat="server" Layout="FitLayout" StyleSpec="background-color:#F0F0F0">
		<Items>
			<ext:Window ID="Window1" runat="server" Maximized="true" Title="Kategorilere Atanan �r�nler" Layout="FitLayout"
				Icon="PackageStart" Closable="false" Minimizable="false" MinHeight="480" MinWidth="640">
				<Items>
					<ext:GridPanel ID="GridPanel1" runat="server" ColumnLines="true" SortType="AsUCString" AutoExpandColumn="urun"
						OnBeforeClientInit="GridPanelYuklenmedenOnce" AnchorHorizontal="100%" Region="Center" AutoScroll="true" MonitorResize="true" TrackMouseOver="true">
						<Store>
							<ext:Store ID="Store1" runat="server" OnRefreshData="KayitlariYenile" OnAfterRecordDeleted="KayitSil"
								RemoteSort="true">
								<Proxy>
									<ext:PageProxy />
								</Proxy>
								<AutoLoadParams>
									<ext:Parameter Name="start" Value="0" Mode="Raw" />
									<ext:Parameter Name="limit" Value="25" Mode="Raw" />
									<ext:Parameter Name="sort" Value="" />
									<ext:Parameter Name="dir" Value="" />
								</AutoLoadParams>
								<SortInfo Field="id" Direction="DESC" />
								<Reader>
									<ext:JsonReader IDProperty="id">
										<Fields>
											<ext:RecordField Name="id" Type="Int" />
											<ext:RecordField Name="kategori_dil" />
											<ext:RecordField Name="kategori_id" Type="Int" />
											<ext:RecordField Name="kategori" />
											<ext:RecordField Name="kategori_ziyaret" Type="Int" />
											<ext:RecordField Name="urun_id" Type="Int" />
											<ext:RecordField Name="urun_dil" />
											<ext:RecordField Name="urun" />
											<ext:RecordField Name="urun_ziyaret" Type="Int" />
											<ext:RecordField Name="ekleyen" />
											<ext:RecordField Name="tarih_ek" Type="Date" />
											<ext:RecordField Name="guncelleyen" />
											<ext:RecordField Name="tarih_gun" Type="Date" />
										</Fields>
									</ext:JsonReader>
								</Reader>
							</ext:Store>
						</Store>
						<ColumnModel runat="server">
							<Columns>
								<ext:RowNumbererColumn MenuDisabled="true" ColumnID="check" Resizable="false" Editable="false"
									Width="55" />
								<ext:Column DataIndex="id" Header="ID" />
								<ext:Column DataIndex="kategori_id" Header="Kategori ID" Hidden="true" />
								<ext:Column DataIndex="kategori_dil" Header="Kategori Dil" MenuDisabled="true" Sortable="false" Hidden="true"/>
								<ext:Column DataIndex="kategori" Header="Kategori" MenuDisabled="true" Sortable="false" />
								<ext:Column DataIndex="kategori_ziyaret" Header="K. Ziyaret" Width="55" MenuDisabled="true" Sortable="false" />
								<ext:Column DataIndex="urun_id" Header="�r�n ID" Hidden="true"/>
								<ext:Column DataIndex="urun_dil" Header="�r�n Dil" MenuDisabled="true" Sortable="false" Hidden="true"/>
								<ext:Column DataIndex="urun" Header="�r�n" MenuDisabled="true" Sortable="false" />
								<ext:Column DataIndex="urun_ziyaret" Header="�. Ziyaret" Width="55" MenuDisabled="true" Sortable="false" />
								<ext:Column DataIndex="ekleyen" Header="Ekleyen" />
								<ext:DateColumn DataIndex="tarih_ek" Header="Kay�t Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
									Width="125" />
								<ext:Column DataIndex="guncelleyen" Header="G�ncelleyen" />
								<ext:DateColumn DataIndex="tarih_gun" Header="G�ncelleme Tarihi" Align="Center" Format="dd/MM/yyyy - HH:mm:ss"
									Width="125" />
								<ext:CommandColumn Header="��lemler" Align="Center" Width="55" MenuDisabled="true"
									Resizable="false" ButtonAlign="Center">
									<Commands>
										<ext:GridCommand Icon="NoteEdit" CommandName="Duzenle">
											<ToolTip Text="Se�ilen kayd� d�zenle." />
										</ext:GridCommand>
										<ext:CommandSeparator />
									</Commands>
									<Commands>
										<ext:GridCommand Icon="Delete" CommandName="Sil">
											<ToolTip Text="Se�ilen kayd� sil." />
										</ext:GridCommand>
									</Commands>
								</ext:CommandColumn>
								<ext:CommandColumn Header="�K" Align="Center" Width="28" MenuDisabled="true" Resizable="false"
									ButtonAlign="Center">
									<Commands>
										<ext:GridCommand Icon="UserComment" CommandName="IslemKaydi">
											<ToolTip Text="��lem Kayd�n� g�ster" />
										</ext:GridCommand>
									</Commands>
								</ext:CommandColumn>
							</Columns>
						</ColumnModel>
						<Plugins>
							<ext:GridFilters runat="server" ID="GridFilters1" Local="true">
								<Filters>
									<ext:NumericFilter DataIndex="id" />
									<ext:NumericFilter DataIndex="kategori_id" />
									<ext:NumericFilter DataIndex="urun_id" />
									<ext:StringFilter DataIndex="ekleyen" />
									<ext:StringFilter DataIndex="guncelleyen" />
									<ext:DateFilter DataIndex="tarih_ek">
										<DatePickerOptions runat="server" TodayText="Now" />
									</ext:DateFilter>
									<ext:DateFilter DataIndex="tarih_gun">
										<DatePickerOptions runat="server" TodayText="Now" />
									</ext:DateFilter>
								</Filters>
							</ext:GridFilters>
						</Plugins>
						<SelectionModel>
							<ext:CheckboxSelectionModel ID="CheckboxSelectionModel1" runat="server" />
						</SelectionModel>
						<Buttons>
							<ext:Button runat="server" ID="Button1" Text="Yeni" Icon="Add">
								<DirectEvents>
									<Click OnEvent="YeniKayitEkraniGetir">
										<EventMask ShowMask="true" MinDelay="500" Msg="Y�kleniyor..." />
									</Click>
								</DirectEvents>
							</ext:Button>
							<ext:Button runat="server" ID="Button4" Text="Sil" Icon="Delete">
								<DirectEvents>
									<Click OnEvent="SecilenleriSil">
										<Confirmation ConfirmRequest="true" Message="��lemi onayl�yor musunuz?" Title="Onay" />
										<EventMask ShowMask="true" MinDelay="500" Msg="Y�kleniyor..." />
									</Click>
								</DirectEvents>
							</ext:Button>
						</Buttons>
						<LoadMask ShowMask="true" Msg="Y�kleniyor..." />
						<SaveMask ShowMask="true" Msg="Kaydediliyor..." />
						<TopBar>
							<ext:Toolbar ID="Toolbar1" runat="server">
								<Items>
									<ext:ToolbarFill ID="ToolbarFill1" runat="server" />
									<ext:Button ID="ButtonXLS" runat="server" Text="XLS" Icon="PageWhiteExcel">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="xls" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
									<ext:Button ID="ButtonDOC" runat="server" Text="DOC" Icon="PageWhiteWord">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="doc" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
									<ext:Button ID="ButtonCSV" runat="server" Text="CSV" Icon="PageAttach">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="csv" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
									<ext:Button ID="ButtonXML" runat="server" Text="XML" Icon="PageWhiteCode">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="xml" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
									<ext:Button ID="ButtonHTML" runat="server" Text="HTML" Icon="PageWhiteH">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="html" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
									<ext:Button ID="ButtonPDF" runat="server" Text="PDF" Icon="PageWhiteAcrobat">
										<DirectEvents>
											<Click OnEvent="ExportEt" IsUpload="true" Before="ExportYap()">
												<ExtraParams>
													<ext:Parameter Name="data" Value="#{GridPanel1}.getRowsValues()" Mode="Raw" Encode="true" />
													<ext:Parameter Name="format" Value="pdf" Mode="Value" />
												</ExtraParams>
											</Click>
										</DirectEvents>
									</ext:Button>
								</Items>
							</ext:Toolbar>
						</TopBar>
						<BottomBar>
							<ext:PagingToolbar ID="PagingToolbar1" runat="server" PageSize="25">
								<Items>
									<ext:ToolbarSeparator>
									</ext:ToolbarSeparator>
									<ext:Label ID="Label_Sayfalama" runat="server" Text="Sayfalama Say�s� :" />
									<ext:ToolbarSpacer ID="ToolbarSpacer1" runat="server" Width="10" />
									<ext:ComboBox ID="ComboBox1" runat="server" Width="60" Editable="false">
										<Items>
											<ext:ListItem Text="10" />
											<ext:ListItem Text="25" />
											<ext:ListItem Text="50" />
											<ext:ListItem Text="100" />
											<ext:ListItem Text="500" />
											<ext:ListItem Text="1000" />
											<ext:ListItem Text="2500" />
											<ext:ListItem Text="5000" />
										</Items>
										<SelectedItem Value="25" />
										<Listeners>
											<Select Handler="#{PagingToolbar1}.pageSize = parseInt(this.getValue()); #{PagingToolbar1}.doLoad();" />
										</Listeners>
									</ext:ComboBox>
									<ext:ToolbarSpacer ID="ToolbarSpacer2" runat="server" Width="5" />
									<ext:ToolbarSeparator>
									</ext:ToolbarSeparator>
									<ext:Label runat="server" ID="YoneticiAdi" OnBeforeClientInit="YoneticiAdiYaz">
									</ext:Label>
								</Items>
							</ext:PagingToolbar>
						</BottomBar>
						<Listeners>
							<Command Fn="GridKomutlari" />
						</Listeners>
					</ext:GridPanel>
				</Items>
			</ext:Window>
			<ext:Window ID="WindowEkle" runat="server" Modal="false" Resizable="True" Height="500"
				Icon="Add" Title="Ekle" Width="640" Padding="5" Layout="FormLayout" ButtonAlign="Center"
				Shadow="Frame" LabelSeparator=" : " Draggable="True" AutoFocus="True" AutoHeight="True"
				Hidden="true">
				<Items>
				<ext:DropDownField ID="Ekle_DropDownFieldKategoriler" FieldLabel="Kategori"
								runat="server" Editable="false" TriggerIcon="SimpleArrowDown" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan"
								EmptyText="Kategori Se�iniz...">
								<Component>
									<ext:TreePanel Shadow="None" ID="Ekle_TreePanelKategoriler" runat="server" MinWidth="200"
										Title="Kategoriler" Icon="ApplicationSideTree" UseArrows="true" AutoScroll="true"
										Animate="true" EnableDD="false" ContainerScroll="true" RootVisible="False" Selectable="true">
										<Root>
											<ext:AsyncTreeNode NodeID="0" Text="Kategoriler" Icon="ColorSwatch" Expanded="true" />
										</Root>
										<Listeners>
											<BeforeLoad Fn="Ekle_NodeYukleKategoriler" />
											<CheckChange Handler="if(this.lock){return;}if(checked){if(!this.checkedNode){this.checkedNode=node;}else{this.lock=true;this.checkedNode.ui.toggleCheck(false);this.lock=false;this.checkedNode=node;}}else{this.checkedNode=null;};this.dropDownField.setValue(Ekle_KategorilerEkle(this), false)" />
										</Listeners>
									</ext:TreePanel>
								</Component>
							</ext:DropDownField>
					<ext:ComboBox ID="Ekle_ComboBoxUrun" FieldLabel="�r�n" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" runat="server"
						DisplayField="urun" ValueField="id" Editable="true" TypeAhead="true" Mode="Local"
						ForceSelection="true" SelectOnFocus="true" EmptyText="�r�n Se�iniz...">
						<Store>
							<ext:Store ID="StoreUrun1" runat="server" WarningOnDirty="false">
								<Reader>
									<ext:JsonReader>
										<Fields>
											<ext:RecordField Name="id" Type="Int" />
											<ext:RecordField Name="urun" />
										</Fields>
									</ext:JsonReader>
								</Reader>
							</ext:Store>
						</Store>
					</ext:ComboBox>
				</Items>
				<Buttons>
					<ext:Button ID="Ekle_Kaydet" runat="server" Text="Kaydet" Icon="Accept" Type="Submit">
						<Listeners>
							<Click Fn="KaydetKontrol" />
						</Listeners>
						<DirectEvents>
							<Click OnEvent="YeniKayitYap">
								<EventMask ShowMask="true" Msg="Kaydediliyor..." MinDelay="500" />
							</Click>
						</DirectEvents>
					</ext:Button>
				</Buttons>
				<Listeners>
					<Hide Handler="WindowEkleClear()" />
				</Listeners>
			</ext:Window>
			<ext:Window ID="WindowDuzenle" runat="server" Modal="true" Resizable="True" Height="500"
				Icon="NoteEdit" Title="D�zenle" Width="640" Padding="5" Layout="FormLayout" ButtonAlign="Center"
				Shadow="Frame" LabelSeparator=" : " Draggable="True" AutoFocus="True" AutoHeight="True"
				Hidden="true">
				<Items>
					<ext:TextField ID="Duzenle_ID" Hidden="true" runat="server" />
					<ext:TextField ID="Duzenle_KategoriID" Hidden="true" runat="server" />
							<ext:Panel ID="Duzenle_Panel1" runat="server" FormGroup="true" Layout="FormLayout"
								Padding="5" StyleSpec="border:1px solid #C3DAF9;margin-bottom:5px;background:#fff" LabelSeparator=" : ">
								<Content>
									<ext:Checkbox ID="Duzenle_ChecboxKategori" runat="server" FieldLabel="Kategori De�.">
										<Listeners>
											<Check Fn="Duzenle_KategoriDegistir" />
										</Listeners>
									</ext:Checkbox>
									<ext:Label ID="Duzenle_LabelKategori" runat="server" FieldLabel="Kategori" />
									<ext:DropDownField ID="Duzenle_DropDownFieldKategoriler" FieldLabel="Yeni Kategori"
										runat="server" Editable="false" TriggerIcon="SimpleArrowDown" AnchorHorizontal="100%"
										EmptyText="Kategori Se�iniz..." Disabled="true">
										<Component>
											<ext:TreePanel Shadow="None" ID="Duzenle_TreePanelKategoriler" runat="server" MinWidth="200"
												Title="Kategoriler" Icon="ApplicationSideTree" UseArrows="true" AutoScroll="true"
												Animate="true" EnableDD="false" ContainerScroll="true" RootVisible="False" Selectable="true">
												<Root>
													<ext:AsyncTreeNode NodeID="0" Text="Kategoriler" Icon="ColorSwatch" Expanded="true" />
												</Root>
												<Listeners>
													<BeforeLoad Fn="Duzenle_NodeYukleKategoriler" />
													<CheckChange Handler="if(this.lock){return;}if(checked){if(!this.checkedNode){this.checkedNode=node;}else{this.lock=true;this.checkedNode.ui.toggleCheck(false);this.lock=false;this.checkedNode=node;}}else{this.checkedNode=null;};this.dropDownField.setValue(Duzenle_KategorilerEkle(this), false)" />
												</Listeners>
											</ext:TreePanel>
										</Component>
									</ext:DropDownField>
								</Content>
							</ext:Panel>
							<ext:Panel ID="Duzenle_Panel2" runat="server" FormGroup="true" Layout="FormLayout"
								Padding="5" StyleSpec="border:1px solid #C3DAF9;background:#fff" LabelSeparator=" : ">
								<Content>
					<ext:ComboBox ID="Duzenle_ComboBoxUrun" FieldLabel="�r�n" AnchorHorizontal="96%" IndicatorIcon="BulletStar" IndicatorTip="Zorunlu alan" runat="server"
						DisplayField="urun" ValueField="id" Editable="true" TypeAhead="true" Mode="Local"
						ForceSelection="true" SelectOnFocus="true" EmptyText="�r�n Se�iniz...">
						<Store>
							<ext:Store ID="StoreUrun2" runat="server" WarningOnDirty="false">
								<Reader>
									<ext:JsonReader>
										<Fields>
											<ext:RecordField Name="id" Type="Int" />
											<ext:RecordField Name="urun" />
										</Fields>
									</ext:JsonReader>
								</Reader>
							</ext:Store>
						</Store>
					</ext:ComboBox>
					</Content>
					</ext:Panel>
				</Items>
				<Buttons>
					<ext:Button ID="Duzenle_Kaydet" runat="server" Text="G�ncelle" Icon="Accept">
						<Listeners>
							<Click Fn="DuzenleKontrol" />
						</Listeners>
						<DirectEvents>
							<Click OnEvent="GuncellemeYap">
								<EventMask ShowMask="true" Msg="G�ncelleniyor..." MinDelay="500" />
							</Click>
						</DirectEvents>
					</ext:Button>
				</Buttons>
				<Listeners>
					<Hide Handler="WindowDuzenleClear();" />
					<Show Handler="Duzenle_ChecboxKategori.clear(); Duzenle_KategorilerNodeTemizle(); Duzenle_DropDownKategoriler.clear();" />
				</Listeners>
			</ext:Window>
		</Items>
	</ext:Viewport>
	</form>
</body>
</html>
